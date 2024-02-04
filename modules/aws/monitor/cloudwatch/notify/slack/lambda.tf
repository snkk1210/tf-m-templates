/** 
# Lambda
*/

// AWS アカウント Region 参照 
data "aws_region" "self" {}

data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/lambda/source/cloudwatch_alarm_notify.py"
  output_path = "${path.module}/lambda/bin/cloudwatch_alarm_notify.zip"
}

resource "aws_lambda_function" "this" {
  filename                       = data.archive_file.this.output_path
  function_name                  = "${var.common.project}-${var.common.environment}-cloudwatch-alarm-notify-function${var.sfx}"
  description                    = "${var.common.project}-${var.common.environment}-cloudwatch-alarm-notify-function${var.sfx}"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "cloudwatch_alarm_notify.lambda_handler"
  source_code_hash               = data.archive_file.this.output_base64sha256
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = "python3.11"
  environment {
    variables = {
      channelName    = var.env_var.channel_name
      hookUrl        = var.env_var.hook_url
      notificationTo = var.env_var.notification_to
    }
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-cloudwatch-alarm-notify-function${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }

  lifecycle {
    ignore_changes = [
      //environment
    ]
  }
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.this.arn
}