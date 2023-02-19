/** 
# NOTE: AWS Config
*/

// AWS アカウント ID を参照
data "aws_caller_identity" "self" {}

resource "aws_config_configuration_recorder" "awsconfig" {
  name     = "${var.common.project}-${var.common.environment}-awsconfig-configuration-recorder"
  role_arn = aws_iam_role.awsconfig_role.arn

  recording_group {
    all_supported                 = "true"
    include_global_resource_types = "true"
  }
}

resource "aws_config_configuration_recorder_status" "awsconfig" {
  name       = "${var.common.project}-${var.common.environment}-awsconfig-configuration-recorder"
  is_enabled = true
  depends_on = [aws_config_delivery_channel.awsconfig]
}

resource "aws_config_delivery_channel" "awsconfig" {
  name           = "${var.common.project}-${var.common.environment}-awsconfig-delivery-channel"
  s3_bucket_name = aws_s3_bucket.awsconfig.id
  depends_on = [
    aws_config_configuration_recorder.awsconfig
  ]
  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }
}

/** 
# NOTE: IAM Role For AWS Config
*/

resource "aws_iam_role" "awsconfig_role" {
  name = "${var.common.project}-${var.common.environment}-awsconfig-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}

// リソース 読み込み ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "awsconfig_to_all" {
  role       = aws_iam_role.awsconfig_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

// S3 接続 ポリシー
data "aws_iam_policy_document" "awsconfig_to_s3" {

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "${aws_s3_bucket.awsconfig.arn}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "${aws_s3_bucket.awsconfig.arn}"
    ]

    condition {
      test     = "StringLike"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

// S3 接続 ポリシー
resource "aws_iam_policy" "awsconfig_to_s3" {
  name   = "${var.common.project}-${var.common.environment}-awsconfig-to-s3-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.awsconfig_to_s3.json
}

// S3 接続 ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "awsconfig_to_s3" {
  role       = aws_iam_role.awsconfig_role.name
  policy_arn = aws_iam_policy.awsconfig_to_s3.arn
}