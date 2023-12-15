/**
# EventBridge
*/
resource "aws_cloudwatch_event_rule" "this" {
  count = var.enable_auto_deploy ? 1 : 0

  name          = "${var.common.project}-${var.common.environment}-${var.common.service_name}-event-rule"
  description   = "${var.common.service_name} ${var.common.environment} CodeCommit Event Rule"
  event_pattern = data.template_file.event_pattern_build.rendered
}

resource "aws_cloudwatch_event_target" "this" {
  count = var.enable_auto_deploy ? 1 : 0

  rule      = aws_cloudwatch_event_rule.this[count.index].name
  target_id = "${var.common.project}-${var.common.environment}-${var.common.service_name}-event-target"
  arn       = aws_codepipeline.this.arn
  role_arn  = aws_iam_role.eventbridge_role[count.index].arn
}

data "template_file" "event_pattern_build" {
  template = file("${path.module}/event_pattern/codecommit_detection.json")

  vars = {
    codecommit_repository_arn = aws_codecommit_repository.this.arn
    reference_name            = var.reference_name
  }
}

/**
# IAM Role for EventBridge
*/

// EventBridge role
resource "aws_iam_role" "eventbridge_role" {
  count = var.enable_auto_deploy ? 1 : 0

  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-eventbridge-role"

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

// CodePipeline 起動 ポリシー
data "aws_iam_policy_document" "eventbridge_to_codepipeline" {
  count = var.enable_auto_deploy ? 1 : 0

  statement {
    actions = ["codepipeline:StartPipelineExecution"]

    resources = [
      "${aws_codepipeline.this.arn}",
    ]

  }
}

// CodePipeline 起動 ポリシー
resource "aws_iam_policy" "eventbridge_to_codepipeline" {
  count = var.enable_auto_deploy ? 1 : 0

  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-eventbridge-to-codepipeline-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.eventbridge_to_codepipeline[count.index].json
}

// CodePipeline 起動 ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "eventbridge_to_codepipeline" {
  count = var.enable_auto_deploy ? 1 : 0

  role       = aws_iam_role.eventbridge_role[count.index].name
  policy_arn = aws_iam_policy.eventbridge_to_codepipeline[count.index].arn
}