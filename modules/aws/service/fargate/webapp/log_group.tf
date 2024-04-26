/**
# LogGroup
*/

resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/${var.common.project}-${var.common.environment}-${var.common.service_name}-web${var.sfx}"
  retention_in_days = var.ecs_log_retention_in_days

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-web-log-group${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.common.project}-${var.common.environment}-${var.common.service_name}-app${var.sfx}"
  retention_in_days = var.ecs_log_retention_in_days

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-app-log-group${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}