variable "owner" {
    type = string
}

variable "ami_id" {
    type    = string
    default = "ami-099400d52583dd8c4"  # default to Amazon Linux 2
}

variable "instance_type" {
    type    = string
    default = "t3.micro"
}

variable "alb_sg_id" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "target_group_arns" {
    type = list(string)
}

variable "ec2_instance_role_name" {
    type = string
}