resource "aws_db_subnet_group" "this" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-db-subnet-group"
  description = "${var.common.project}-${var.common.environment}-${var.common.service_name}-db-subnet-group"
  subnet_ids  = var.subnet_ids
}