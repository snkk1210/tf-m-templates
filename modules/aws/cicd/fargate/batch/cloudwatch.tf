/**
# CodeBuild Log
*/
resource "aws_cloudwatch_log_group" "codebuild" {
  name              = "/codebuild/${var.common.environment}/${var.common.service_name}"
  retention_in_days = 400
}