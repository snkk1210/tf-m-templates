output "cloudwatch_alarm_notify_sns_topic_arn" {
  value = aws_sns_topic.cloudwatch_alarm.arn
}