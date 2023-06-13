/** 
# NOTE: EventBridge For Batch-Failed
*/

// Batch 実行結果のイベントルール
resource "aws_cloudwatch_event_rule" "batch_failed_event_rule" {
  name        = "${var.common.project}-${var.common.environment}-batch-failed-event-rule"
  description = "${var.common.project}-${var.common.environment}-batch-failed-event-rule"

  event_pattern = <<EOF
{
  "detail-type": [
      "Batch Job State Change"
  ],
  "source": [
      "aws.batch"
  ],
  "detail": {
      "status": [
          "FAILED"
      ]
  }
}
EOF
}

// Batch 実行結果の SNS 通知ルール
resource "aws_cloudwatch_event_target" "batch_failed_event_target" {
  rule      = aws_cloudwatch_event_rule.batch_failed_event_rule.name
  target_id = "${var.common.project}-${var.common.environment}-batch-failed-notify-sns-topic"
  arn       = aws_sns_topic.batch_failed.arn

  // JSON を整形して出力
  input_transformer {
    input_paths = {
      time                = "$.time",
      jobArn              = "$.detail.jobArn",
      jobId               = "$.detail.jobId",
      jobName             = "$.detail.jobName",
      jobQueue            = "$.detail.jobQueue",
      status              = "$.detail.status",
      statusReason        = "$.detail.statusReason",
      awslogsGroup        = "$.detail.container.logConfiguration.options.awslogs-group",
      awslogsStreamPrefix = "$.detail.container.logConfiguration.options.awslogs-stream-prefix",
    }
    input_template = <<EOF
{
  "time": <time>,
  "jobArn": <jobArn>,
  "jobId": <jobId>,
  "jobName": <jobName>,
  "jobQueue": <jobQueue>,
  "status": <status>,
  "statusReason": <statusReason>,
  "awslogsGroup": <awslogsGroup>,
  "awslogsStreamPrefix": <awslogsStreamPrefix>
}
EOF
  }
}

// Batch 実行結果の SNS 通知トピック
resource "aws_sns_topic" "batch_failed" {
  name         = "${var.common.project}-${var.common.environment}-batch-failed-notify-sns-topic"
  display_name = "${var.common.project}-${var.common.environment}-batch-failed-notify-sns-topic"
}

// Batch 実行結果の SNS 通知トピック ポリシー
resource "aws_sns_topic_policy" "batch_failed" {
  arn    = aws_sns_topic.batch_failed.arn
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

    resources = [aws_sns_topic.batch_failed.arn]
  }
}


/** 
# NOTE: IAM Role For Batch-Failed Lambda
*/

// Lambda role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.common.project}-${var.common.environment}-batch-failed-notify-lambda-role"
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
  name = "${var.common.project}-${var.common.environment}-batch-failed-notify-lambda-policy"
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
resource "aws_kms_key" "batch_failed_lambda" {
  description             = "${var.common.project}-${var.common.environment}-batch-failed-notify-lambda-kms"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

// 環境変数暗号化 KMS Alias
resource "aws_kms_alias" "batch_failed_lambda" {
  name          = "alias/${var.common.project}/${var.common.environment}/batch_failed_notify_lambda_kms_key"
  target_key_id = aws_kms_key.batch_failed_lambda.id
}