/** 
# NOTE: Lambda
*/

data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/lambda/source/health_event_slack_notify.py"
  output_path = "${path.module}/lambda/bin/health_event_slack_notify.zip"
}

resource "aws_lambda_function" "this" {
  filename                       = data.archive_file.this.output_path
  function_name                  = "${var.common.project}-${var.common.environment}-health-event-slack-notify-function${var.sfx}"
  description                    = "${var.common.project}-${var.common.environment}-health-event-slack-notify-function${var.sfx}"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "health_event_slack_notify.lambda_handler"
  source_code_hash               = data.archive_file.this.output_base64sha256
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = "python3.12"

  environment {
    variables = {
      channelName    = var.env_var.channel_name
      hookUrl        = var.env_var.hook_url
      notificationTo = var.env_var.notification_to
    }
  }

  lifecycle {
    ignore_changes = [
      //environment
    ]
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-health-event-slack-notify-function${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.this.arn
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.this.arn
}