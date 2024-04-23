resource "aws_rds_cluster" "this" {
  cluster_identifier              = "${var.common.project}-${var.common.environment}-${var.common.service_name}-db-cluster${var.sfx}"
  master_username                 = var.aurora_cluster.master_username
  master_password                 = var.aurora_cluster.master_password
  engine                          = var.aurora_cluster.engine
  engine_version                  = var.aurora_cluster.engine_version
  port                            = var.aurora_cluster.port
  apply_immediately               = var.aurora_cluster.apply_immediately
  storage_encrypted               = var.aurora_cluster.storage_encrypted
  kms_key_id                      = local.kms_key_id
  db_subnet_group_name            = aws_db_subnet_group.this.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
  preferred_backup_window         = var.aurora_cluster.preferred_backup_window
  preferred_maintenance_window    = var.aurora_cluster.preferred_maintenance_window
  backup_retention_period         = var.aurora_cluster.backup_retention_period
  deletion_protection             = var.aurora_cluster.deletion_protection
  skip_final_snapshot             = var.aurora_cluster.skip_final_snapshot
  final_snapshot_identifier       = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.service_name}-db-cluster-final-snapshot"
  vpc_security_group_ids          = ["${aws_security_group.this.id}"]
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-db-cluster${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_rds_cluster_instance" "this" {
  count                                 = var.aurora_cluster_instance.count
  identifier                            = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${format("db%02d", count.index + 1)}"
  cluster_identifier                    = aws_rds_cluster.this.cluster_identifier
  instance_class                        = var.aurora_cluster_instance.instance_class
  engine                                = var.aurora_cluster_instance.engine
  engine_version                        = var.aurora_cluster_instance.engine_version
  publicly_accessible                   = var.aurora_cluster_instance.publicly_accessible
  auto_minor_version_upgrade            = var.aurora_cluster_instance.auto_minor_version_upgrade
  db_parameter_group_name               = aws_db_parameter_group.this.name
  preferred_maintenance_window          = var.aurora_cluster.preferred_maintenance_window
  monitoring_role_arn                   = aws_iam_role.aurora_expansion_monitoring.arn
  monitoring_interval                   = 60
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = local.performance_insights_retention_period
  performance_insights_kms_key_id       = local.performance_insights_kms_key_id
  promotion_tier                        = 1

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${format("db%02d", count.index + 1)}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

locals {
  performance_insights_retention_period = var.performance_insights_enabled == true ? 7 : null
  performance_insights_kms_key_id       = var.performance_insights_enabled == true ? data.aws_kms_key.rds.arn : null
  kms_key_id                            = var.aurora_cluster.storage_encrypted == true ? data.aws_kms_key.rds.arn : null
}