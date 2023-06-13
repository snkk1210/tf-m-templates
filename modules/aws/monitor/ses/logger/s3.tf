resource "aws_s3_bucket" "logger" {
  bucket = "${var.common.project}-${var.common.environment}-ses-log-bucket"

  tags = {
    Name = "${var.common.project}-${var.common.environment}-ses-log-bucket"
  }
}

resource "aws_s3_bucket_versioning" "logger" {
  bucket = aws_s3_bucket.logger.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "logger" {
  bucket = aws_s3_bucket.logger.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logger" {
  bucket = aws_s3_bucket.logger.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
