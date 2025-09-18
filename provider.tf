terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38" # latest stable
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
  load_config_file       = false
}

