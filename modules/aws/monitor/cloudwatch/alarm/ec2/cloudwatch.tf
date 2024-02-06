/** 
# CloudWatch Alarm EC2
*/

// EC2 CPUUtilization 
resource "aws_cloudwatch_metric_alarm" "ec2_cpuutilization" {
  for_each = { for alarm in var.ec2_instance_alarms : alarm.ec2_instance_name => alarm }

  alarm_name          = "${each.value.ec2_instance_name}-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.ec2_cpuutilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = each.value.ec2_cpuutilization_period
  statistic           = each.value.ec2_cpuutilization_statistic
  threshold           = each.value.ec2_cpuutilization_threshold
  alarm_description   = "${each.value.ec2_instance_name}-CPUUtilization"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    InstanceId = "${each.value.ec2_instance_id}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// EC2 StatusCheckFailed
resource "aws_cloudwatch_metric_alarm" "ec2_statuscheckfailed" {
  for_each = { for alarm in var.ec2_instance_alarms : alarm.ec2_instance_name => alarm }

  alarm_name          = "${each.value.ec2_instance_name}-StatusCheckFailed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.ec2_statuscheckfailed_evaluation_periods
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = each.value.ec2_statuscheckfailed_period
  statistic           = each.value.ec2_statuscheckfailed_statistic
  threshold           = each.value.ec2_statuscheckfailed_threshold
  alarm_description   = "${each.value.ec2_instance_name}-StatusCheckFailed"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    InstanceId = "${each.value.ec2_instance_id}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}