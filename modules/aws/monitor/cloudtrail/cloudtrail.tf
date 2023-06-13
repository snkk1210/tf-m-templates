/** 
# NOTE: CloudTrail
*/

// AWS アカウント ID 参照
data "aws_caller_identity" "self" {}

// AWS アカウント Region 参照 
data "aws_region" "self" {}

/** 
# NOTE: Cloudtrail IAM
*/

// GurdDuty → KMS ポリシー
data "aws_iam_policy_document" "cloudtrail_to_kms" {

  // Enable IAM User Permissions
  statement {
    actions = [
      "kms:*"
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.self.account_id}:root"]
    }

  }

  // Allow CloudTrail to encrypt logs
  statement {
    actions = [
      "kms:GenerateDataKey*"
    ]

    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.self.account_id}:trail/*"]
    }

  }

  // Allow CloudTrail to describe key
  statement {
    actions = [
      "kms:DescribeKey"
    ]

    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

  }

  // Allow principals in the account to decrypt log files
  statement {
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.self.account_id}:trail/*"]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = ["${data.aws_caller_identity.self.account_id}"]
    }

  }

  // Allow alias creation during setup
  statement {
    actions = [
      "kms:CreateAlias"
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = ["${data.aws_caller_identity.self.account_id}"]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ec2.ap-northeast-1.amazonaws.com"]
    }

  }

  // Enable cross account log decryption
  statement {
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = ["${data.aws_caller_identity.self.account_id}"]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.self.account_id}:trail/*"]
    }

  }

}

resource "aws_iam_role" "cloudtrail_role" {
  name               = "${var.common.project}-${var.common.environment}-cloudtrail-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cloudtrail_to_cw" {
  name = "${var.common.project}-${var.common.environment}-cloudtrail-to-cw-policy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrail",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudtrail_to_cw" {
  role       = aws_iam_role.cloudtrail_role.name
  policy_arn = aws_iam_policy.cloudtrail_to_cw.arn
}

/** 
# NOTE: Cloudtrail
*/

// CloudTrail KMS
resource "aws_kms_key" "cloudtrail" {
  description             = "${var.common.project}-${var.common.environment}-cloudtrail-kms"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true

  policy = data.aws_iam_policy_document.cloudtrail_to_kms.json
}

// CloudTrail KMS Alias
resource "aws_kms_alias" "cloudtrail" {
  name          = "alias/${var.common.project}/${var.common.environment}/cloudtrail_kms_key"
  target_key_id = aws_kms_key.cloudtrail.id
}

// CloudTrail
resource "aws_cloudtrail" "cloudtrail" {
  name           = "${var.common.project}-${var.common.environment}-trail"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id

  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_key.cloudtrail.arn

  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_role.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-trail"
    Environment = var.common.environment
  }
}

// CloudTrail ログ保存バケット
resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.common.project}-${var.common.environment}-trail-bucket"
  force_destroy = true
}

// CloudTrail S3 バケット ライフサイクル設定
resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    id     = "CloudTrail_GLACIER_390Days_Expiration_1110Days"
    status = "Enabled"

    transition {
      days          = 390
      storage_class = "GLACIER"
    }

    expiration {
      days = 1110
    }
  }
}

// S3 パブリックアクセス設定
resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// S3 暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// CloudTrail S3 ポリシー アタッチ
resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail_to_s3.json
}

// CloudTrail → S3 ポリシー
data "aws_iam_policy_document" "cloudtrail_to_s3" {
  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.cloudtrail.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      aws_s3_bucket.cloudtrail.arn
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

// CloudTrail CloudWatch Logs Group
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/codebuild/${var.common.environment}/trail"
  retention_in_days = 400
}