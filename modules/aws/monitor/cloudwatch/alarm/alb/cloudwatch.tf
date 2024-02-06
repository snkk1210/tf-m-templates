/** 
# CloudWatch Alarm ALB
*/

// ALB HTTPCode_ELB_5XX_Count
resource "aws_cloudwatch_metric_alarm" "alb_httpcode_elb_5xx_count" {
  for_each = { for alarm in var.alb_alarms : alarm.alb_name => alarm }

  alarm_name          = "${each.value.alb_name}-HTTPCode_ELB_5XX_Count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.alb_httpcode_elb_5xx_count_evaluation_periods
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = each.value.alb_httpcode_elb_5xx_count_period
  statistic           = each.value.alb_httpcode_elb_5xx_count_statistic
  threshold           = each.value.alb_httpcode_elb_5xx_count_threshold
  alarm_description   = "${each.value.alb_name}-HTTPCode_ELB_5XX_Count"
  treat_missing_data  = "notBreaching"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    LoadBalancer = "${each.value.alb_arn}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}


// ALB HTTPCode_Target_5XX_Count
resource "aws_cloudwatch_metric_alarm" "alb_httpcode_target_5xx_count" {
  for_each = { for alarm in var.alb_alarms : alarm.alb_name => alarm }

  alarm_name          = "${each.value.alb_name}-HTTPCode_Target_5XX_Count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.alb_httpcode_target_5xx_count_evaluation_periods
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = each.value.alb_httpcode_target_5xx_count_period
  statistic           = each.value.alb_httpcode_target_5xx_count_statistic
  threshold           = each.value.alb_httpcode_target_5xx_count_threshold
  alarm_description   = "${each.value.alb_name}-HTTPCode_Target_5XX_Count"
  treat_missing_data  = "notBreaching"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    LoadBalancer = "${each.value.alb_arn}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

