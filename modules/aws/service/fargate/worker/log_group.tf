/**
# LogGroup
*/

// ECS
resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.common.project}-${var.common.environment}-${var.common.service_name}${var.sfx}"
  retention_in_days = var.ecs_log_retention_in_days

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-log-group${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}