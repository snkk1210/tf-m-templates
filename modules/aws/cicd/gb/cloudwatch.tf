/**
# CodeBuild Log
*/
resource "aws_cloudwatch_log_group" "codebuild" {
  name              = "/codebuild/${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-project${var.sfx}"
  retention_in_days = var.retention_in_days
}