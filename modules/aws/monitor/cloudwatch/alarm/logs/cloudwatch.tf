/** 
# CloudWatch Alarm
*/

// CloudWatch Logs Alarm
resource "aws_cloudwatch_metric_alarm" "log_detection" {
  for_each = { for filter in var.log_metric_filters : filter.log_filter_name => filter }

  alarm_name          = "${var.common.project}-${each.value.log_filter_name}-${var.common.environment}-log-detection-alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.log_detection_evaluation_periods
  metric_name         = "${var.common.project}-${each.value.log_filter_name}-${var.common.environment}-log-detection"
  namespace           = "LogFilter"
  period              = each.value.log_detection_period
  statistic           = each.value.log_detection_statistic
  threshold           = each.value.log_detection_threshold
  alarm_description   = "${var.common.project}-${each.value.log_filter_name}-${var.common.environment}-log-detection-alert"
  treat_missing_data  = "notBreaching"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}