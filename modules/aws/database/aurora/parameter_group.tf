/** 
# Parameter Group
*/
resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-rds-cluster-pg${var.sfx}"
  description = "${var.common.project}-${var.common.environment}-${var.common.service_name}-rds-cluster-pg${var.sfx}"
  family      = var.rds_cluster_parameter_group.family

  dynamic "parameter" {
    for_each = var.rds_cluster_parameter_group.parameter

    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }

  /** 
  # MEMO: For PostgreSQL
  parameter {
    name         = "client_encoding"
    value        = "UTF8"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "pgaudit.log"
    value = "all"
  }

  parameter {
    name  = "pgaudit.role"
    value = "rds_pgaudit"
  }

  parameter {
    name         = "shared_preload_libraries"
    value        = "pgaudit"
    apply_method = "pending-reboot"
  }

  lifecycle {
    ignore_changes = [
      parameter,
    ]
  }
  */

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-rds-cluster-pg${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_db_parameter_group" "this" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-rds-pg${var.sfx}"
  description = "${var.common.project}-${var.common.environment}-${var.common.service_name}-rds-pg${var.sfx}"
  family      = var.db_parameter_group.family

  dynamic "parameter" {
    for_each = var.db_parameter_group.parameter

    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-rds-pg${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}