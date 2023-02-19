/** 
# NOTE: S3 Bucket For GuardDuty
*/

// S3 Bucket GuardDuty
resource "aws_s3_bucket" "guardduty" {
  bucket = "${var.common.project}-${var.common.environment}-${data.aws_region.self.name}-guardduty-bucket"
  //force_destroy = true
}

// GuardDuty S3 バケット ライフサイクル設定
resource "aws_s3_bucket_lifecycle_configuration" "guardduty" {
  bucket = aws_s3_bucket.guardduty.id

  rule {
    id     = "GuardDuty_GLACIER_390Days_Expiration_1110Days"
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

// GuardDuty S3 バケット ACL
resource "aws_s3_bucket_acl" "guardduty" {
  bucket = aws_s3_bucket.guardduty.id
  acl    = "private"
}

// GuardDuty S3 ポリシー アタッチ
resource "aws_s3_bucket_policy" "guardduty" {
  bucket = aws_s3_bucket.guardduty.id
  policy = data.aws_iam_policy_document.guardduty_to_s3.json
}

// S3 パブリックアクセス設定
resource "aws_s3_bucket_public_access_block" "guardduty" {
  bucket = aws_s3_bucket.guardduty.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// S3 暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "guardduty" {
  bucket = aws_s3_bucket.guardduty.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}