#Terraform AWS Infrastructure Project

This project provisions a **production-ready AWS infrastructure** using **Terraform** with modular design and workspace separation for Dev, Staging, and Prod environments.

Features
- **Infrastructure-as-Code (IaC)** using Terraform
- **Remote Backend**: S3 (with versioning) + DynamoDB for state locking
- **Networking**: VPC with public/private subnets, NAT gateways, Internet Gateway
- **Compute**: EKS cluster with managed node groups (Kubernetes workloads)
- **Database**: RDS (Postgres) with Multi-AZ(optional)
- **Storage**: S3 buckets with encryption, versioning, and public access block
- **Load Balancing**: Application Load Balancer (ALB)
- **Security**: IAM roles/policies, Security Groups, KMS encryption
- **CI/CD Ready**: GitHub Actions / Jenkins integration
- **Observability**: Prometheus, Grafana





### 1️⃣ Prerequisites
- [Terraform v1.13+](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI configured (`aws configure`)
- Git installed

### 2️⃣Initialize Terraform

terraform init

--Select Workspace
terraform workspace new dev     
terraform workspace select dev

--Plan and Apply
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars


Future Enhancements

Add AWS Secrets Manager / Vault integration

Add Chaos Engineering with LitmusChaos

Add cost monitoring with AWS Budgets


Chirag Goyal
📧 chiraggoyalcg640@gmail.com
🔗 linkedin.com/in/chirag-goyal-cg640/
