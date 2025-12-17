module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  owner                = var.owner
}

module "alb" {
  source = "./modules/alb"

  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  owner               = var.owner
  acm_certificate_arn = var.acm_certificate_arn
}

module "compute" {
  source = "./modules/compute"

  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  private_subnet_ids     = module.vpc.private_subnet_ids
  ec2_instance_role_name = var.ec2_instance_role_name
  target_group_arns      = [module.alb.target_group_arn]
  vpc_id                 = module.vpc.vpc_id
  alb_sg_id              = module.alb.lb_sg_id
  owner                  = var.owner
}