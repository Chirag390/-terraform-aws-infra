terraform {
  backend "s3" {
    bucket         = "chirag-goyal-prsnl-project"
    key            = "global/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tfstate-locks"
    encrypt        = true
  }
}

