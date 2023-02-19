/**
# NOTE: S3 Bucket For AWS Config
*/

// S3 許可ポリシー
data "aws_iam_policy_document" "awsconfig_bucket" {

  // AWS Config → S3 ポリシー
  statement {

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      "${aws_s3_bucket.awsconfig.arn}"
    ]

  }

  statement {

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.awsconfig.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

  }

}

// ログ保管 S3
resource "aws_s3_bucket" "awsconfig" {
  bucket = "${var.common.project}-${var.common.environment}-awsconfig-bucket"

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-awsconfig-bucket"
    Environment = var.common.environment
  }
}

// Log S3 バケット ライフサイクル設定
resource "aws_s3_bucket_lifecycle_configuration" "awsconfig" {
  bucket = aws_s3_bucket.awsconfig.id

  rule {
    id     = "AWSCONFIG_GLACIER_390Days_Expiration_2557Days"
    status = "Enabled"

    transition {
      days          = 390
      storage_class = "GLACIER"
    }

    expiration {
      days = 2557
    }
  }
}

// ALB S3 ポリシー アタッチ
resource "aws_s3_bucket_policy" "awsconfig" {
  bucket = aws_s3_bucket.awsconfig.id
  policy = data.aws_iam_policy_document.awsconfig_bucket.json
}

// S3 パブリックアクセス設定
resource "aws_s3_bucket_public_access_block" "awsconfig" {
  bucket = aws_s3_bucket.awsconfig.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// S3 暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "awsconfig" {
  bucket = aws_s3_bucket.awsconfig.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
