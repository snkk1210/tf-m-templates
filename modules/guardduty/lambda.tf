/** 
# NOTE: Lambda
*/

// ソース ZIP 化
data "archive_file" "guardduty_finding" {
  type        = "zip"
  source_file = "${path.module}/lambda/source/guardduty_finding_notify.py"
  output_path = "${path.module}/lambda/bin/guardduty_finding_notify.zip"
}

// Lambda Function
resource "aws_lambda_function" "guardduty_finding" {
  filename                       = data.archive_file.guardduty_finding.output_path
  function_name                  = "${var.common.project}-${var.common.environment}-guardduty-finding-notify-function"
  description                    = "${var.common.project}-${var.common.environment}-guardduty-finding-notify-function"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "guardduty_finding_notify.lambda_handler"
  source_code_hash               = data.archive_file.guardduty_finding.output_base64sha256
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = "python3.9"
  environment {
    variables = {
      channelName         = var.channel_name
      kmsEncryptedHookUrl = var.kms_encrypted_hookurl
      TZ                  = var.lambda_timezone
    }
  }

  lifecycle {
    ignore_changes = [
      environment
    ]
  }

}

// SNS 紐づけ
resource "aws_lambda_permission" "guardduty_finding" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.guardduty_finding.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.guardduty_finding.arn
}

// SNS Subscription
resource "aws_sns_topic_subscription" "guardduty_finding" {
  topic_arn = aws_sns_topic.guardduty_finding.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.guardduty_finding.arn
}