/**
# CodeBuild Log
*/
resource "aws_cloudwatch_log_group" "this" {
  name              = "/codebuild/${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild${var.sfx}"
  retention_in_days = 30

  tags = {
    Name        = "/codebuild/${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}