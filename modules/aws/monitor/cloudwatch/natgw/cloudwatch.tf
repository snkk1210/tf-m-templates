/** 
# CloudWatch Alarm NatGW
*/

// NatGW ErrorPortAllocation
resource "aws_cloudwatch_metric_alarm" "natgw_errorportallocation" {
  for_each = { for instance in var.natgw_instance_alarm : instance.natgw_instance_name => instance }

  alarm_name          = "${each.value.natgw_instance_name}-ErrorPortAllocation"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.natgw_errorportallocation_evaluation_periods
  metric_name         = "ErrorPortAllocation"
  namespace           = "AWS/NATGateway"
  period              = each.value.natgw_errorportallocation_period
  statistic           = each.value.natgw_errorportallocation_statistic
  threshold           = each.value.natgw_errorportallocation_threshold
  alarm_description   = "${each.value.natgw_instance_name}-ErrorPortAllocation"
  treat_missing_data  = "notBreaching"

  alarm_actions             = var.notify_sns_topic_arn
  ok_actions                = var.notify_sns_topic_arn
  insufficient_data_actions = []

  dimensions = {
    NatGatewayId = "${each.value.natgw_instance_id}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}