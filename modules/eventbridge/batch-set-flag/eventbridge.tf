/** 
# NOTE: EventBridge For Batch-Set-Flag
*/

// Batch 実行結果のイベントルール
resource "aws_cloudwatch_event_rule" "batch_set_flag_event_rule" {
  name        = "${var.common.project}-${var.common.environment}-batch-set-flag-event-rule"
  description = "${var.common.project}-${var.common.environment}-batch-set-flag-event-rule"

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
          "SUCCEEDED",
          "FAILED"
      ]
  }
}
EOF
}

// Batch 実行結果の SNS 通知ルール
resource "aws_cloudwatch_event_target" "batch_set_flag_event_target" {
  rule      = aws_cloudwatch_event_rule.batch_set_flag_event_rule.name
  target_id = "${var.common.project}-${var.common.environment}-batch-set-flag-sns-topic"
  arn       = aws_sns_topic.batch_set_flag.arn

  // JSON を整形して出力
  input_transformer {
    input_paths = {
      jobName = "$.detail.jobName",
    }
    input_template = <<EOF
{
  "jobName": <jobName>
}
EOF
  }
}

// Batch 実行結果の SNS 通知トピック
resource "aws_sns_topic" "batch_set_flag" {
  name         = "${var.common.project}-${var.common.environment}-batch-set-flag-sns-topic"
  display_name = "${var.common.project}-${var.common.environment}-batch-set-flag-sns-topic"
}

// Batch 実行結果の SNS 通知トピック ポリシー
resource "aws_sns_topic_policy" "batch_set_flag" {
  arn    = aws_sns_topic.batch_set_flag.arn
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

    resources = [aws_sns_topic.batch_set_flag.arn]
  }
}


/** 
# NOTE: IAM Role For Batch-Set-Flag Set Flag Lambda
*/

// Lambda role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.common.project}-${var.common.environment}-batch-set-flag-lambda-role"
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

// S3 ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "lambda_to_s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}