
resource "aws_kms_key" "aurora_storage" {
  description             = "${var.common.project}-${var.common.environment}-${var.common.service_name}-aurora-storage-kms"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

resource "aws_kms_alias" "aurora_storage" {
  name          = "alias/${var.common.project}/${var.common.environment}/${var.common.service_name}/aurora_storage_kms_key"
  target_key_id = aws_kms_key.aurora_storage.id
}

resource "aws_kms_key" "aurora_performance_insights" {
  count      = var.performance_insights_enabled ? 1 : 0
  description             = "${var.common.project}-${var.common.environment}-${var.common.service_name}-aurora-performance-insights-kms"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

resource "aws_kms_alias" "aurora_performance_insights" {
  count      = var.performance_insights_enabled ? 1 : 0
  name          = "alias/${var.common.project}/${var.common.environment}/${var.common.service_name}/aurora_performance_insights_kms_key"
  target_key_id = aws_kms_key.aurora_performance_insights[0].id
}