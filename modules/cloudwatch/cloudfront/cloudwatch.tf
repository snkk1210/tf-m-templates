/** 
# NOTE: CloudWatch Alarm CloudFront
*/

// CloudFront 5xxErrorRate
resource "aws_cloudwatch_metric_alarm" "cloudfront_5xxerrorrate" {

  for_each = { for service in var.cloudfront_alarm : service.cloudfront_name => service }

  alarm_name          = "${var.common.project}-${each.value.cloudfront_name}-${var.common.environment}-cloudfront-5xxErrorRate"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.cloudfront_5xxerrorrate_evaluation_periods
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = each.value.cloudfront_5xxerrorrate_period
  statistic           = each.value.cloudfront_5xxerrorrate_statistic
  threshold           = each.value.cloudfront_5xxerrorrate_threshold
  alarm_description   = "${var.common.project}-${each.value.cloudfront_name}-${var.common.environment}-cloudfront-5xxErrorRate"
  treat_missing_data  = "notBreaching"

  alarm_actions             = [var.cloudwatch_alarm_notify_sns_topic_arn]
  ok_actions                = [var.cloudwatch_alarm_notify_sns_topic_arn]
  insufficient_data_actions = []

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