/**
# NOTE: S3 Bucket For Batch Flag
*/

// ENV S3
resource "aws_s3_bucket" "batch_flag" {
  bucket = "${var.common.project}-${var.common.environment}-batch-flag-bucket"

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-batch-flag-bucket"
    Environment = var.common.environment
  }
}

// S3 パブリックアクセス設定
resource "aws_s3_bucket_public_access_block" "batch_flag" {
  bucket = aws_s3_bucket.batch_flag.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// S3 バケット ライフサイクル設定
resource "aws_s3_bucket_lifecycle_configuration" "batch_flag" {
  bucket = aws_s3_bucket.batch_flag.id

  rule {
    id     = "BATCH_FLAG_Expiration_7Days"
    status = "Enabled"

    expiration {
      days = 7
    }
  }
}

// S3 暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "batch_flag" {
  bucket = aws_s3_bucket.batch_flag.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}