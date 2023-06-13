/** 
# NOTE: Lambda
*/

data "archive_file" "batch_set_flag" {
  type        = "zip"
  source_file = "${path.module}/lambda/source/batch_set_flag.py"
  output_path = "${path.module}/lambda/bin/batch_set_flag.zip"
}

resource "aws_lambda_function" "batch_set_flag" {
  filename                       = data.archive_file.batch_set_flag.output_path
  function_name                  = "${var.common.project}-${var.common.environment}-batch-set-flag-function"
  description                    = "${var.common.project}-${var.common.environment}-batch-set-flag-function"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "batch_set_flag.lambda_handler"
  source_code_hash               = data.archive_file.batch_set_flag.output_base64sha256
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = "python3.9"

  environment {
    variables = {
      s3BucketName   = var.s3_bucket_name
      s3BucketRegion = var.s3_bucket_region
      TZ             = var.lambda_timezone
    }
  }

  lifecycle {
    ignore_changes = [
      //environment
    ]
  }

}

resource "aws_lambda_permission" "batch_set_flag" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.batch_set_flag.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.batch_set_flag.arn
}

resource "aws_sns_topic_subscription" "batch_set_flag" {
  topic_arn = aws_sns_topic.batch_set_flag.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.batch_set_flag.arn
}