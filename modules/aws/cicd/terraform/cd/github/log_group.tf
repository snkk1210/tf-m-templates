/**
# CodeBuild Log
*/
resource "aws_cloudwatch_log_group" "plan" {
  name              = "/codebuild/${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-plan-codebuild${var.sfx}"
  retention_in_days = 30

  tags = {
    Name        = "/codebuild/${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-plan-codebuild${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "apply" {
  name              = "/codebuild/${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-apply-codebuild${var.sfx}"
  retention_in_days = 30

  tags = {
    Name        = "/codebuild/${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-apply-codebuild${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}