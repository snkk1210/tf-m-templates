/** 
# S3
*/

data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "alb_log" {
  bucket        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-alb-log-s3-bucket${var.sfx}"
  force_destroy = var.force_destroy

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-alb-log-s3-bucket${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  versioning_configuration {
    status = var.versioning_configuration
  }
}

resource "aws_s3_bucket_public_access_block" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "alb_log_to_s3" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.alb_log.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log_to_s3.json
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    id     = "Log_Expiration"
    status = "Enabled"

    transition {
      days          = var.log_rule.glacier_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.log_rule.expiration_days
    }
  }
}