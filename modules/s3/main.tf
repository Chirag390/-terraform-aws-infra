resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-${var.environment}-bucket"
  acl    = "private"

  tags = var.tags
}

# Move versioning to a separate resource
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

