/** 
# NOTE: SNS
*/

// SNS 通知トピック
resource "aws_sns_topic" "ses_email_receiving" {
  name = "${var.common.project}-${var.common.environment}-ses-email-receiving-notify-sns-topic"
}

resource "aws_sns_topic_subscription" "ses_email_receiving" {
  topic_arn = aws_sns_topic.ses_email_receiving.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ses_email_receiving.arn
}