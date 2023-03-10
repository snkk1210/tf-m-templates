/** 
# NOTE: CloudWatch Alarm EC2
*/

// EC2 CPUUtilization 
resource "aws_cloudwatch_metric_alarm" "ec2_cpuutilization" {
  for_each = { for instance in var.ec2_instance_alarm : instance.ec2_instance_name => instance }

  alarm_name          = "${each.value.ec2_instance_name}-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.ec2_cpuutilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = each.value.ec2_cpuutilization_period
  statistic           = each.value.ec2_cpuutilization_statistic
  threshold           = each.value.ec2_cpuutilization_threshold
  alarm_description   = "${each.value.ec2_instance_name}-CPUUtilization"

  alarm_actions             = [var.cloudwatch_alarm_notify_sns_topic_arn]
  ok_actions                = [var.cloudwatch_alarm_notify_sns_topic_arn]
  insufficient_data_actions = []

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
  for_each = { for instance in var.ec2_instance_alarm : instance.ec2_instance_name => instance }

  alarm_name          = "${each.value.ec2_instance_name}-StatusCheckFailed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.ec2_statuscheckfailed_evaluation_periods
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = each.value.ec2_statuscheckfailed_period
  statistic           = each.value.ec2_statuscheckfailed_statistic
  threshold           = each.value.ec2_statuscheckfailed_threshold
  alarm_description   = "${each.value.ec2_instance_name}-StatusCheckFailed"

  alarm_actions             = [var.cloudwatch_alarm_notify_sns_topic_arn]
  ok_actions                = [var.cloudwatch_alarm_notify_sns_topic_arn]
  insufficient_data_actions = []

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