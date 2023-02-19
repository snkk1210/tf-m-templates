/** 
# NOTE: EventBridge For GuardDuty Finding
*/

// GuardDuty 検知時のイベントルール
resource "aws_cloudwatch_event_rule" "guardduty_finding_event_rule" {
  name        = "${var.common.project}-${var.common.environment}-guardduty-finding-event-rule"
  description = "${var.common.project}-${var.common.environment}-guardduty-finding-event-rule"

  /** 
  # https://docs.aws.amazon.com/ja_jp/guardduty/latest/ug/guardduty_findings_cloudwatch.html
  # https://dev.classmethod.jp/articles/guardduty-event-filter/
  */
  event_pattern = <<EOF
{
    "source": [
        "aws.guardduty"
    ],
    "detail-type": [
        "GuardDuty Finding"
    ],
    "detail": {
        "severity": [
            { "numeric": [ ">=", 4 ] }
        ]
    }
}
EOF
}

// GuardDuty 検知時の SNS 通知ルール
resource "aws_cloudwatch_event_target" "guardduty_finding_event_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_finding_event_rule.name
  target_id = "${var.common.project}-${var.common.environment}-guardduty-finding-notify-sns-topic"
  arn       = aws_sns_topic.guardduty_finding.arn

  // JSON を整形して出力
  input_transformer {
    input_paths = {
      account        = "$.account",
      time           = "$.time",
      region         = "$.region",
      id             = "$.detail.id",
      arn            = "$.detail.arn",
      resourceType   = "$.detail.resource.resourceType",
      type           = "$.detail.type",
      serviceName    = "$.detail.service.serviceName",
      detectorId     = "$.detail.service.detectorId",
      severity       = "$.detail.severity",
      title          = "$.detail.title",
      description    = "$.detail.description",
      eventFirstSeen = "$.detail.service.eventFirstSeen",
      eventLastSeen  = "$.detail.service.eventLastSeen",
    }
    input_template = <<EOF
{
  "account": <account>,
  "time": <time>,
  "region": <region>,
  "id": <id>,
  "arn": <arn>,
  "resourceType": <resourceType>,
  "type": <type>,
  "serviceName": <serviceName>,
  "detectorId": <detectorId>,
  "severity": <severity>,
  "title": <title>,
  "description": <description>,
  "eventFirstSeen": <eventFirstSeen>,
  "eventLastSeen": <eventLastSeen>
}
EOF
  }
}


// GuardDuty 検知時の SNS 通知トピック
resource "aws_sns_topic" "guardduty_finding" {
  name         = "${var.common.project}-${var.common.environment}-guardduty-finding-notify-sns-topic"
  display_name = "${var.common.project}-${var.common.environment}-guardduty-finding-notify-sns-topic"
}

// GuardDuty 検知時の SNS 通知トピック ポリシー
resource "aws_sns_topic_policy" "guardduty_finding" {
  arn    = aws_sns_topic.guardduty_finding.arn
  policy = data.aws_iam_policy_document.eventbridge_to_sns.json
}

// SNS Publish ポリシー
data "aws_iam_policy_document" "eventbridge_to_sns" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.guardduty_finding.arn]
  }
}

/** 
# NOTE: IAM Role For GuardDuty Lambda
*/

// Lambda role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.common.project}-${var.common.environment}-${data.aws_region.self.name}-guardduty-finding-notify-lambda-role"
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
  name = "${var.common.project}-${var.common.environment}-${data.aws_region.self.name}-guardduty-finding-notify-lambda-policy"
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
resource "aws_kms_key" "guardduty_finding_lambda" {
  description             = "${var.common.project}-${var.common.environment}-guardduty-finding-notify-lambda-kms"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

// 環境変数暗号化 KMS Alias
resource "aws_kms_alias" "guardduty_finding_lambda" {
  name          = "alias/${var.common.project}/${var.common.environment}/guardduty_finding_notify_lambda_kms_key"
  target_key_id = aws_kms_key.guardduty_finding_lambda.id
}