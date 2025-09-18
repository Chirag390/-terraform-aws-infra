variable "project_name" { type = string }
variable "environment"  { type = string }
variable "vpc_cidr"     { type = string }
variable "public_subnets_cidrs"  { type = list(string) }
variable "private_subnets_cidrs" { type = list(string) }
variable "tags" {
  type    = map(string)
  default = {}
}

