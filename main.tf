locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
  })
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  public_subnets_cidrs  = var.public_subnet_cidrs
  private_subnets_cidrs = var.private_subnet_cidrs
  tags         = local.common_tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.3.1"

  name    = "${local.name_prefix}-eks"
  kubernetes_version = var.cluster_version

  vpc_id  = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  eks_managed_node_groups = {
    standard = {
      desired_capacity = var.node_desired_capacity
      min_capacity     = 1
      max_capacity     = 4
      instance_types   = var.node_instance_types
      key_name         = var.ec2_key_name
    }
  }

  tags = local.common_tags
}



module "rds" {
  source       = "./modules/rds"
  project_name = var.project_name
  environment  = var.environment
  db_username  = var.db_username
  db_password  = var.db_password
  vpc_id       = module.vpc.vpc_id
  db_subnet_group = module.vpc.db_subnet_group
  tags         = local.common_tags
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

module "alb" {
  source       = "./modules/alb"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  tags         = local.common_tags
}

