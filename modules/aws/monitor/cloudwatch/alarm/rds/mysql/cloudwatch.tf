/** 
# CloudWatch Alarm RDS
*/

// RDS CPUUtilization
resource "aws_cloudwatch_metric_alarm" "rds_cpuutilization" {
  for_each = { for alarm in var.rds_alarms : alarm.rds_name => alarm }

  alarm_name          = "${each.value.rds_name}-CPUUtilization${var.sfx}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.rds_cpuutilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = each.value.rds_cpuutilization_period
  statistic           = each.value.rds_cpuutilization_statistic
  threshold           = each.value.rds_cpuutilization_threshold
  alarm_description   = "${each.value.rds_name}-CPUUtilization${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

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
  for_each = { for alarm in var.rds_alarms : alarm.rds_name => alarm }

  alarm_name          = "${each.value.rds_name}-FreeableMemory${var.sfx}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.rds_freeablememory_evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = each.value.rds_freeablememory_period
  statistic           = each.value.rds_freeablememory_statistic
  threshold           = each.value.rds_freeablememory_threshold
  alarm_description   = "${each.value.rds_name}-FreeableMemory${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

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

// RDS FreeStorageSpace
resource "aws_cloudwatch_metric_alarm" "rds_freestoragespace" {
  for_each = { for alarm in var.rds_alarms : alarm.rds_name => alarm }

  alarm_name          = "${each.value.rds_name}-FreeStorageSpace${var.sfx}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.rds_freestoragespace_evaluation_periods
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = each.value.rds_freestoragespace_period
  statistic           = each.value.rds_freestoragespace_statistic
  threshold           = each.value.rds_freestoragespace_threshold
  alarm_description   = "${each.value.rds_name}-FreeStorageSpace${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

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