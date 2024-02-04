/** 
# NOTE: CloudWatch Alarm SES
*/

// SES Reputation.BounceRate
resource "aws_cloudwatch_metric_alarm" "ses_reputation_bouncerate" {
  alarm_name          = "${var.project}-${var.environment}-ses-Reputation-BounceRate-alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Reputation.BounceRate"
  namespace           = "AWS/SES"
  period              = "300"
  statistic           = "Average"
  threshold           = "0.05"
  alarm_description   = "${var.project}-${var.environment}-ses-Reputation-BounceRate-alert"
  treat_missing_data  = "notBreaching"

  alarm_actions             = var.notify_sns_topic_arn
  ok_actions                = var.notify_sns_topic_arn
  insufficient_data_actions = []

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }

}

// SES Reputation.ComplaintRate
resource "aws_cloudwatch_metric_alarm" "ses_reputation_complaintrate" {
  alarm_name          = "${var.project}-${var.environment}-ses-Reputation-ComplaintRate-alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Reputation.ComplaintRate"
  namespace           = "AWS/SES"
  period              = "300"
  statistic           = "Average"
  threshold           = "0.001"
  alarm_description   = "${var.project}-${var.environment}-ses-Reputation-ComplaintRate-alert"
  treat_missing_data  = "notBreaching"

  alarm_actions             = var.notify_sns_topic_arn
  ok_actions                = var.notify_sns_topic_arn
  insufficient_data_actions = []

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}