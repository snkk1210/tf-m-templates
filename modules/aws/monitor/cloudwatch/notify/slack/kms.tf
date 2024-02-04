/** 
# KMS
*/
// 環境変数暗号化 KMS
resource "aws_kms_key" "this" {
  count                   = var.enable_kms ? 1 : 0
  description             = "${var.common.project}-${var.common.environment}-cloudwatch-alarm-notify-lambda-kms${var.sfx}"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

// 環境変数暗号化 KMS Alias
resource "aws_kms_alias" "this" {
  count         = var.enable_kms ? 1 : 0
  name          = "alias/${var.common.project}/${var.common.environment}/cloudwatch_alarm_notify_lambda_kms_key${var.sfx}"
  target_key_id = aws_kms_key.this[0].id
}