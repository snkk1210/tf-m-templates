/** 
# CloudWatch Alarm CloudFront
*/

// CloudFront 5xxErrorRate
resource "aws_cloudwatch_metric_alarm" "cloudfront_5xxerrorrate" {
  for_each = { for alarm in var.cloudfront_alarms : alarm.cloudfront_name => alarm }

  alarm_name          = "${each.value.cloudfront_name}-cloudfront-5xxErrorRate${var.sfx}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.cloudfront_5xxerrorrate_evaluation_periods
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = each.value.cloudfront_5xxerrorrate_period
  statistic           = each.value.cloudfront_5xxerrorrate_statistic
  threshold           = each.value.cloudfront_5xxerrorrate_threshold
  alarm_description   = "${each.value.cloudfront_name}-cloudfront-5xxErrorRate${var.sfx}"
  treat_missing_data  = "notBreaching"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    DistributionId = "${each.value.cloudfront_id}"
    Region         = "Global"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}