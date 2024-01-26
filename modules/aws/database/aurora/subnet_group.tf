resource "aws_db_subnet_group" "this" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-db-subnet-group${var.sfx}"
  description = "${var.common.project}-${var.common.environment}-${var.common.service_name}-db-subnet-group${var.sfx}"
  subnet_ids  = var.subnet_ids

  tags = {
    Name      = "${var.common.project}-${var.common.environment}-${var.common.service_name}-db-subnet-group${var.sfx}"
    Environment = var.common.environment
    Createdby = "Terraform"
  }
}