/** 
# NOTE: Enhanced-Scanning EventBridge
*/

// 拡張スキャン Finding 実行結果のイベントルール
resource "aws_cloudwatch_event_rule" "ecr_enhanced_scanning_finding_event_rule" {
  name        = "${var.common.project}-${var.common.environment}-ecr-enhanced-scanning-finding-event-rule"
  description = "${var.common.project}-${var.common.environment}-ecr-enhanced-scanning-finding-event-rule"

  event_pattern = <<EOF
{
  "source": ["aws.inspector2"],
  "detail-type": ["Inspector2 Finding"],
  "detail": {
    "status": ["ACTIVE"],
    "severity": ["CRITICAL"]
  }
}
EOF
}

// 拡張スキャン Finding 実行結果の SNS 通知ルール
resource "aws_cloudwatch_event_target" "ecr_enhanced_scanning_finding_event_target" {
  rule      = aws_cloudwatch_event_rule.ecr_enhanced_scanning_finding_event_rule.name
  target_id = "${var.common.project}-${var.common.environment}-ecr-enhanced-scanning-finding-notify-sns-topic"
  arn       = aws_sns_topic.ecr_enhanced_scanning_finding.arn

  // JSON を整形して出力
  input_transformer {
    input_paths = {
      resources       = "$.resources",
      firstObservedAt = "$.detail.firstObservedAt",
      lastObservedAt  = "$.detail.lastObservedAt",
      updatedAt       = "$.detail.updatedAt",
      title           = "$.detail.title",
      status          = "$.detail.status",
      severity        = "$.detail.severity",
      inspectorScore  = "$.detail.inspectorScore",
      sourceUrl       = "$.detail.packageVulnerabilityDetails.sourceUrl",
    }
    input_template = <<EOF
{
  "resources": <resources>,
  "firstObservedAt": <firstObservedAt>,
  "lastObservedAt": <lastObservedAt>,
  "updatedAt": <updatedAt>,
  "title": <title>,
  "status": <status>,
  "severity": <severity>,
  "inspectorScore": <inspectorScore>,
  "sourceUrl": <sourceUrl>
}
EOF
  }
}

/** 
# NOTE: Enhanced-Scanning SNS
*/

// 拡張スキャン Finding 実行結果の SNS 通知トピック
resource "aws_sns_topic" "ecr_enhanced_scanning_finding" {
  name         = "${var.common.project}-${var.common.environment}-ecr-enhanced-scanning-finding-notify-sns-topic"
  display_name = "${var.common.project}-${var.common.environment}-ecr-enhanced-scanning-finding-notify-sns-topic"
}

// 拡張スキャン Finding 実行結果の SNS 通知トピック ポリシー
resource "aws_sns_topic_policy" "ecr_enhanced_scanning_finding" {
  arn    = aws_sns_topic.ecr_enhanced_scanning_finding.arn
  policy = data.aws_iam_policy_document.eventbridge_to_sns.json
}

// SNS Finding Publish ポリシー
data "aws_iam_policy_document" "eventbridge_to_sns" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.ecr_enhanced_scanning_finding.arn]
  }
}

/** 
# NOTE: IAM Role For Enhanced-Scanning Lambda
*/

// Lambda role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.common.project}-${var.common.environment}-ecr-enhanced-scanning-finding-notify-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

// Lambda 基本実行 ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

/**
# NOTE: 利用しない
// CloudWatch ReadOnly ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "lambda_to_cw" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}
*/

// SSM パラメータ 読み込み ポリシー
resource "aws_iam_policy" "lambda_to_ssm" {
  name = "${var.common.project}-${var.common.environment}-ecr-enhanced-scanning-finding-notify-lambda-policy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

// SSM パラメータ 読み込み ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "lambda_to_ssm" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_to_ssm.arn
}

// 環境変数暗号化 KMS
resource "aws_kms_key" "ecr_enhanced_scanning_finding_lambda" {
  description             = "${var.common.project}-${var.common.environment}-ecr-enhanced-scanning-finding-notify-lambda-kms"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

// 環境変数暗号化 KMS Alias
resource "aws_kms_alias" "ecr_enhanced_scanning_finding_lambda" {
  name          = "alias/${var.common.project}/${var.common.environment}/ecr_enhanced_scanning_finding_notify_lambda_kms_key"
  target_key_id = aws_kms_key.ecr_enhanced_scanning_finding_lambda.id
}