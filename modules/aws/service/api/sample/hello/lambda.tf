/**
# Lambda
*/
data "archive_file" "api" {
  type        = "zip"
  source_file = "${path.module}/lambda/source/lambda-api.py"
  output_path = "${path.module}/lambda/bin/lambda-api.zip"
}

resource "aws_lambda_function" "api" {
  filename                       = data.archive_file.api.output_path
  function_name                  = "${var.common.project}-${var.common.environment}-hello-function"
  description                    = "Created by Terraform"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "lambda-api.lambda_handler"
  source_code_hash               = data.archive_file.api.output_base64sha256
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = "python3.9"

  /**
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.api.id]
  }
  */

  environment {
    variables = {
      //
    }
  }

  lifecycle {
    ignore_changes = [
      //
    ]
  }

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-hello-function"
    Createdby = "Terraform"
  }

}

/**
# APIGateway Connection
*/
resource "aws_lambda_permission" "api" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*"
}