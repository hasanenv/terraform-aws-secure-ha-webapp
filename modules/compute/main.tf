resource "aws_security_group" "compute_sg" {
  vpc_id      = var.vpc_id

    # inbound http from ALB only

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [var.alb_sg_id]
    }

    # outbound all traffic

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "all"
        cidr_blocks = ["0.0.0.0/0"]
    }

tags = local.tags
}

# to allow ec2 instances to read site files from s3 bucket
data "aws_iam_role" "ec2_role" {   
    name = var.ec2_instance_role_name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
    role = data.aws_iam_role.ec2_role.name

tags = local.tags
}

# launch template for compute instances
resource "aws_launch_template" "compute_lt" {
    image_id               = var.ami_id
    instance_type          = var.instance_type
    vpc_security_group_ids = [aws_security_group.compute_sg.id] 
    iam_instance_profile {
        name               = aws_iam_instance_profile.ec2_instance_profile.name
    }
    user_data              = filebase64("${path.module}/cloud-init.yaml") # cloud-init file to install nginx

tags = local.tags
}

resource "aws_autoscaling_group" "compute_asg" {
    vpc_zone_identifier = var.private_subnet_ids
    desired_capacity    = 2
    min_size            = 2
    max_size            = 2

  launch_template {
    id      = aws_launch_template.compute_lt.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns

    health_check_type           = "ELB"
    health_check_grace_period   = 300

    tag {
            key                 = "Owner"
            value               = var.owner
            propagate_at_launch = true
        } 
}