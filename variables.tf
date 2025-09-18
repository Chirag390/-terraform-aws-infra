variable "project_name" {
  type    = string
  default = "kubenexus"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "db_username" {
  type    = string
  default = "kubeadmin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_desired_capacity" {
  type    = number
  default = 1
}

variable "enable_multi_az_rds" {
  type    = bool
  default = false
}

variable "ec2_key_name" {
  description = "EC2 Key Pair for SSH into worker nodes"
  type        = string
  default     = "ec2learning.pem"  
}

variable "tags" {
  type = map(string)
  default = {
    Owner = "chirag"
    Team  = "DevOps"
  }
}

