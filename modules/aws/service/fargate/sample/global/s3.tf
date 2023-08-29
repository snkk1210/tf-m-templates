// AWS アカウント ID 参照
data "aws_caller_identity" "current_identity" {}

// ALB のアカウント ID 参照
data "aws_elb_service_account" "alblog" {}

// S3 許可ポリシー
data "aws_iam_policy_document" "alblog" {

  // ALB → S3 ポリシー
  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.common.project}-${var.common.service_name}-${var.common.environment}-alblog-bucket/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_elb_service_account.alblog.id}:root",
      ]
    }
  }

  // S3 → S3 ポリシー
  statement {
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${var.common.project}-${var.common.service_name}-${var.common.environment}-alblog-bucket/*"
    ]
    principals {
      type = "Service"
      identifiers = [
        "logging.s3.amazonaws.com"
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:s3:::*"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        "${data.aws_caller_identity.current_identity.account_id}"
      ]
    }
  }

}

resource "aws_s3_bucket" "alblog" {
  bucket        = "${var.common.project}-${var.common.service_name}-${var.common.environment}-alblog-bucket"
  force_destroy = true

  tags = {
    Name      = "${var.common.project}-${var.common.service_name}-${var.common.environment}-alblog-bucket"
    Createdby = "Terraform"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "alblog" {
  bucket = aws_s3_bucket.alblog.id

  rule {
    id     = "GLACIER_390Days_Expiration_1095Days"
    status = "Enabled"

    transition {
      days          = 390
      storage_class = "GLACIER"
    }

    expiration {
      days = 1095
    }
  }
}

resource "aws_s3_bucket_policy" "alblog" {
  bucket = aws_s3_bucket.alblog.id
  policy = data.aws_iam_policy_document.alblog.json
}

resource "aws_s3_bucket_public_access_block" "alblog" {
  bucket = aws_s3_bucket.alblog.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alblog" {
  bucket = aws_s3_bucket.alblog.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}