/** 
# NOTE: SNS
*/

// SNS 通知トピック
resource "aws_sns_topic" "cloudwatch_alarm" {
  name         = "${var.common.project}-${var.common.environment}-cloudwatch-alarm-notify-sns-topic"
  display_name = "${var.common.project}-${var.common.environment}-cloudwatch-alarm-notify-sns-topic"
}

resource "aws_sns_topic_subscription" "cloudwatch_alarm" {
  topic_arn = aws_sns_topic.cloudwatch_alarm.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.cloudwatch_alarm.arn
}