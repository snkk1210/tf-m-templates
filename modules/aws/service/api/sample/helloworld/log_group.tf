/**
# CloudWatch LogGroup For APIGateway
*/
resource "aws_cloudwatch_log_group" "apigateway_api01" {
  name              = "/apigateway/${var.common.project}-${var.common.environment}-helloworld-agw"
  retention_in_days = 14

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-helloworld-agw-log-group"
    Createdby = "Terraform"
  }
}

/**
# CloudWatch LogGroup For Lambda
*/
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.common.project}-${var.common.environment}-helloworld-function"
  retention_in_days = 14

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-helloworld-function-log-group"
    Createdby = "Terraform"
  }
}