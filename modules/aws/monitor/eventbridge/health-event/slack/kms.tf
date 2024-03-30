/** 
# KMS
*/

// 環境変数暗号化 KMS
resource "aws_kms_key" "health_notify_lambda" {
  count                   = var.enable_kms ? 1 : 0
  description             = "${var.common.project}-${var.common.environment}-health-event-slack-notify-lambda-kms${var.sfx}"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

// 環境変数暗号化 KMS Alias
resource "aws_kms_alias" "health_notify_lambda" {
  count         = var.enable_kms ? 1 : 0
  name          = "alias/${var.common.project}/${var.common.environment}/health_event_slack_notify_kms_key${var.sfx}"
  target_key_id = aws_kms_key.health_notify_lambda.id
}