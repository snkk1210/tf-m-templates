/**
# S3 ( Artifact )
*/
resource "aws_s3_bucket" "this" {
  bucket        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-artifact-s3-bucket${var.sfx}"
  force_destroy = var.s3_bucket_force_destroy

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-artifact-s3-bucket${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "Artifact_Expiration"
    status = "Enabled"

    expiration {
      days = var.artifact_expiration_days
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}