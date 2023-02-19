/** 
# NOTE: GuardDuty
*/

// AWS アカウント ID 参照
data "aws_caller_identity" "self" {}

// AWS アカウント Region 参照 
data "aws_region" "self" {}

// GuardDuty → S3 ポリシー
data "aws_iam_policy_document" "guardduty_to_s3" {
  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.guardduty.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "s3:GetBucketLocation"
    ]

    resources = [
      aws_s3_bucket.guardduty.arn
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }
}

// GurdDuty → KMS ポリシー
data "aws_iam_policy_document" "guardduty_to_kms" {

  statement {
    actions = [
      "kms:GenerateDataKey"
    ]

    resources = [
      "arn:aws:kms:${data.aws_region.self.name}:${data.aws_caller_identity.self.account_id}:key/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "kms:*"
    ]

    resources = [
      "arn:aws:kms:${data.aws_region.self.name}:${data.aws_caller_identity.self.account_id}:key/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.self.account_id}:root"]
    }
  }

}

// GuardDuty
resource "aws_guardduty_detector" "guardduty" {
  enable = true
}

// GurardDuty KMS KEY
resource "aws_kms_key" "guardduty" {
  description             = "${var.common.project}-${var.common.environment}-guardduty-key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.guardduty_to_kms.json
}

// GuardDuty KMS KEY Alias
resource "aws_kms_alias" "guardduty" {
  name          = "alias/${var.common.project}/${var.common.environment}/guardduty_kms_key"
  target_key_id = aws_kms_key.guardduty.id
}

// GuardDuty ログ出力先
resource "aws_guardduty_publishing_destination" "guardduty_publishing_destination" {
  detector_id     = aws_guardduty_detector.guardduty.id
  destination_arn = aws_s3_bucket.guardduty.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  depends_on = [
    aws_s3_bucket_policy.guardduty,
  ]
}

/**
# NOTE: EventBridge でフィルタリングを行う
// GuardDuty Fillter
resource "aws_guardduty_filter" "guardduty_filter" {
  name        = "${var.common.project}-${var.common.environment}-guardduty-filter"
  action      = "ARCHIVE"
  detector_id = aws_guardduty_detector.guardduty.id
  rank        = 4

  finding_criteria {
    criterion {
      field     = "severity"
      less_than = "4"
    }
  }
}
*/