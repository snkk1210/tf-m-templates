/**
# Artifact S3
*/
resource "aws_s3_bucket" "artifact" {
  bucket = "${var.common.project}-${var.common.environment}-${var.common.service_name}-artifact-bucket"
  force_destroy = true

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-${var.common.service_name}-artifact-bucket"
    Createdby = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "artifact" {
  bucket = aws_s3_bucket.artifact.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact" {
  bucket = aws_s3_bucket.artifact.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}