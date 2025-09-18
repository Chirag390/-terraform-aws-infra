resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  vpc_id      = var.vpc_id
  description = "RDS SG"
  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier        = "${var.project_name}-${var.environment}-db"
  engine            = var.engine
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  name              = "${var.project_name}"
  username          = var.db_username
  password          = var.db_password
  db_subnet_group_name = var.db_subnet_group
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot = true
  multi_az = var.multi_az
  tags = var.tags
}

