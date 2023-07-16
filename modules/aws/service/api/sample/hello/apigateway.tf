/** 
# APIGateway
*/
resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.common.project}-${var.common.environment}-hello-agw"
  description = "Created by Terraform"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = {
    Name      = "${var.common.project}-${var.common.environment}-hello-agw"
    Createdby = "Terraform"
  }
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_MATCH"
  uri                     = aws_lambda_function.api.invoke_arn
}

resource "aws_api_gateway_stage" "api_stage" {
  depends_on  = [aws_api_gateway_account.api]
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.stage_name

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigateway_api.arn
    format          = "$context.identity.sourceIp $context.identity.caller $context.identity.user [$context.requestTime] \"$context.httpMethod $context.resourcePath $context.protocol\" $context.status $context.responseLength $context.requestId"
  }

  lifecycle {
    ignore_changes = [
      //deployment_id
    ]
  }
}

resource "aws_api_gateway_method_settings" "api_method_settings" {
  depends_on  = [aws_api_gateway_account.api]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_deployment" "api" {
  depends_on  = [aws_api_gateway_rest_api.api, aws_api_gateway_integration.api_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = var.redeployment_version
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_gateway_response" "api_gateway_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  response_parameters = {}
  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }
  response_type = "INTEGRATION_FAILURE"
  status_code   = "504"
}

resource "aws_api_gateway_integration_response" "api_integration_response" {
  depends_on          = [aws_api_gateway_integration.api_integration]
  http_method         = "POST"
  content_handling    = "CONVERT_TO_TEXT"
  response_parameters = {}
  response_templates  = {}
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_rest_api.api.root_resource_id
  status_code         = "200"
}

resource "aws_api_gateway_method_response" "api_method_response" {
  depends_on  = [aws_api_gateway_method.api_method]
  http_method = "POST"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {}
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_rest_api.api.root_resource_id
  status_code         = "200"
}

/**
# IAM For APIGateway
*/
data "aws_iam_policy_document" "api_gateway_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.api.execution_arn}/*"]
  }
}

resource "aws_api_gateway_rest_api_policy" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  policy      = data.aws_iam_policy_document.api_gateway_policy.json
}