// SES FeedBack 転送先 SNS 通知トピック
resource "aws_sns_topic" "ses_feedback" {
  name         = "${var.common.project}-${var.common.environment}-ses-feedback-sns-topic"
  display_name = "${var.common.project}-${var.common.environment}-ses-feedback-sns-topic"
}