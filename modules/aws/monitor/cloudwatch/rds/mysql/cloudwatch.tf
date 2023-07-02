/** 
# NOTE: CloudWatch Alarm RDS
*/

// RDS CPUUtilization
resource "aws_cloudwatch_metric_alarm" "rds_cpuutilization" {
  for_each = { for rds in var.rds_alarm : rds.rds_name => rds }

  alarm_name          = "${each.value.rds_name}-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.rds_cpuutilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = each.value.rds_cpuutilization_period
  statistic           = each.value.rds_cpuutilization_statistic
  threshold           = each.value.rds_cpuutilization_threshold
  alarm_description   = "${each.value.rds_name}-CPUUtilization"

  alarm_actions             = [var.cloudwatch_alarm_notify_sns_topic_arn]
  ok_actions                = [var.cloudwatch_alarm_notify_sns_topic_arn]
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = "${each.value.rds_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }

}

// RDS FreeableMemory
resource "aws_cloudwatch_metric_alarm" "rds_freeablememory" {
  for_each = { for rds in var.rds_alarm : rds.rds_name => rds }

  alarm_name          = "${each.value.rds_name}-FreeableMemory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.rds_freeablememory_evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = each.value.rds_freeablememory_period
  statistic           = each.value.rds_freeablememory_statistic
  threshold           = each.value.rds_freeablememory_threshold
  alarm_description   = "${each.value.rds_name}-FreeableMemory"

  alarm_actions             = [var.cloudwatch_alarm_notify_sns_topic_arn]
  ok_actions                = [var.cloudwatch_alarm_notify_sns_topic_arn]
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = ""
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }

}

// RDS FreeStorageSpace
resource "aws_cloudwatch_metric_alarm" "rds_freestoragespace" {
  for_each = { for rds in var.rds_alarm : rds.rds_name => rds }

  alarm_name          = "${each.value.rds_name}-FreeStorageSpace"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.rds_freestoragespace_evaluation_periods
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = each.value.rds_freestoragespace_period
  statistic           = each.value.rds_freestoragespace_statistic
  threshold           = each.value.rds_freestoragespace_threshold
  alarm_description   = "${each.value.rds_name}-FreeStorageSpace"

  alarm_actions             = [var.cloudwatch_alarm_notify_sns_topic_arn]
  ok_actions                = [var.cloudwatch_alarm_notify_sns_topic_arn]
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = "${each.value.rds_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }

}