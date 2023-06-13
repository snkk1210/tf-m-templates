/** 
# NOTE: Lambda
*/

data "archive_file" "batch_failed" {
  type        = "zip"
  source_file = "${path.module}/lambda/source/batch_failed_notify.py"
  output_path = "${path.module}/lambda/bin/batch_failed_notify.zip"
}

resource "aws_lambda_function" "batch_failed" {
  filename                       = data.archive_file.batch_failed.output_path
  function_name                  = "${var.common.project}-${var.common.environment}-batch-failed-notify-function"
  description                    = "${var.common.project}-${var.common.environment}-batch-failed-notify-function"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "batch_failed_notify.lambda_handler"
  source_code_hash               = data.archive_file.batch_failed.output_base64sha256
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

resource "aws_lambda_permission" "batch_failed" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.batch_failed.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.batch_failed.arn
}

resource "aws_sns_topic_subscription" "batch_failed" {
  topic_arn = aws_sns_topic.batch_failed.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.batch_failed.arn
}