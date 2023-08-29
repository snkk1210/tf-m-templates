resource "aws_ecs_cluster" "cluster" {
  name = "${var.common.project}-${var.common.environment}-cluster"

  setting {
    name  = var.ecs_cluster.setting_name
    value = var.ecs_cluster.setting_value
  }

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-cluster"
    Createdby = "Terraform"
  }
}