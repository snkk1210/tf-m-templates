/**
# CloudWatch LogGroup For APIGateway
*/
resource "aws_cloudwatch_log_group" "apigateway_api" {
  name              = "/apigateway/${var.common.project}-${var.common.environment}-hello-agw"
  retention_in_days = 14

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-hello-agw-log-group"
    Createdby = "Terraform"
  }
}

/**
# CloudWatch LogGroup For Lambda
*/
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.common.project}-${var.common.environment}-hello-function"
  retention_in_days = 14

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-hello-function-log-group"
    Createdby = "Terraform"
  }
}