/** 
# NOTE: SNS
*/

// SNS 通知トピック
resource "aws_sns_topic" "this" {
  name         = "${var.common.project}-${var.common.environment}-cwalarm-notify-sns-topic${var.sfx}"
  display_name = "${var.common.project}-${var.common.environment}-cwalarm-notify-sns-topic${var.sfx}"

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-cwalarm-notify-sns-topic${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.this.arn
}