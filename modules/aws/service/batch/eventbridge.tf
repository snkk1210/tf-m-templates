/**
# CloudWatch Event For Batch
*/
resource "aws_cloudwatch_event_rule" "batch_event_rule" {
  name                = "${var.common.project}-${var.common.environment}-${var.common.service_name}-cron-event-rule"
  description         = "${var.common.service_name} Schedule Batch Event Rule"
  schedule_expression = var.batch_cron
}

resource "aws_cloudwatch_event_target" "batch_event_target" {
  rule     = aws_cloudwatch_event_rule.batch_event_rule.name
  arn      = aws_batch_job_queue.batch_job_queue.arn
  role_arn = aws_iam_role.eventbridge_role.arn

  batch_target {
    job_definition = aws_batch_job_definition.batch_job_definition.arn
    job_name       = "${var.common.project}-${var.common.environment}-${var.common.service_name}-batch-job"
  }


}

/**
# IAM Role for EventBridge
*/

// EventBridge role
resource "aws_iam_role" "eventbridge_role" {

  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-cron-eventbridge-role"

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}

// AWS Batch 起動 ポリシー
data "aws_iam_policy_document" "eventbridge_to_batch" {

  statement {
    actions = [
      "batch:*"
    ]

    resources = [
      "*",
    ]

  }
}

// AWS Batch 起動 ポリシー
resource "aws_iam_policy" "eventbridge_to_batch" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-eventbridge-to-batch-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.eventbridge_to_batch.json
}

// AWS Batch 起動 ポリシー　アタッチ
resource "aws_iam_role_policy_attachment" "eventbridge_to_batch" {
  role       = aws_iam_role.eventbridge_role.name
  policy_arn = aws_iam_policy.eventbridge_to_batch.arn
}