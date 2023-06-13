/** 
# NOTE: Lambda
*/

data "archive_file" "ecr_enhanced_scanning_finding" {
  type        = "zip"
  source_file = "${path.module}/lambda/source/ecr_enhanced_scanning_finding_notify.py"
  output_path = "${path.module}/lambda/bin/ecr_enhanced_scanning_finding_notify.zip"
}

resource "aws_lambda_function" "ecr_enhanced_scanning_finding" {
  filename                       = data.archive_file.ecr_enhanced_scanning_finding.output_path
  function_name                  = "${var.common.project}-${var.common.environment}-ecr-enhanced-scan-finding-notify-function"
  description                    = "${var.common.project}-${var.common.environment}-ecr-enhanced-scan-finding-notify-function"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "ecr_enhanced_scanning_finding_notify.lambda_handler"
  source_code_hash               = data.archive_file.ecr_enhanced_scanning_finding.output_base64sha256
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

resource "aws_lambda_permission" "ecr_enhanced_scanning_finding" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecr_enhanced_scanning_finding.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.ecr_enhanced_scanning_finding.arn
}

resource "aws_sns_topic_subscription" "ecr_enhanced_scanning_finding" {
  topic_arn = aws_sns_topic.ecr_enhanced_scanning_finding.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ecr_enhanced_scanning_finding.arn
}