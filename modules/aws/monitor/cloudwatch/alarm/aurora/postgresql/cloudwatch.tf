/** 
# loudWatch Alarm Aurora PostgreSQL
*/

// Aurora Cluster Writer CPUUtilization 
resource "aws_cloudwatch_metric_alarm" "aurora_writer_cpuutilization" {
  for_each = { for alarm in var.aurora_cluster_alarms : alarm.aurora_cluster_name => alarm }

  alarm_name          = "${each.value.aurora_cluster_name}-writer-CPUUtilization${var.sfx}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_writer_cpuutilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_writer_cpuutilization_period
  statistic           = each.value.aurora_writer_cpuutilization_statistic
  threshold           = each.value.aurora_writer_cpuutilization_threshold
  alarm_description   = "${each.value.aurora_cluster_name}-writer-CPUUtilization${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    DBClusterIdentifier = "${each.value.aurora_cluster_name}"
    Role                = "WRITER"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// Aurora Cluster Reader CPUUtilization
resource "aws_cloudwatch_metric_alarm" "aurora_reader_cpuutilization" {
  for_each = { for alarm in var.aurora_cluster_alarms : alarm.aurora_cluster_name => alarm }

  alarm_name          = "${each.value.aurora_cluster_name}-reader-CPUUtilization${var.sfx}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_reader_cpuutilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_reader_cpuutilization_period
  statistic           = each.value.aurora_reader_cpuutilization_statistic
  threshold           = each.value.aurora_reader_cpuutilization_threshold
  alarm_description   = "${each.value.aurora_cluster_name}-reader-CPUUtilization${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    DBClusterIdentifier = "${each.value.aurora_cluster_name}"
    Role                = "READER"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// Aurora Cluster Writer FreeableMemory
resource "aws_cloudwatch_metric_alarm" "aurora_writer_freeablememory" {
  for_each = { for alarm in var.aurora_cluster_alarms : alarm.aurora_cluster_name => alarm }

  alarm_name          = "${each.value.aurora_cluster_name}-writer-FreeableMemory${var.sfx}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_writer_freeablememory_evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_writer_freeablememory_period
  statistic           = each.value.aurora_writer_freeablememory_statistic
  threshold           = each.value.aurora_writer_freeablememory_threshold
  alarm_description   = "${each.value.aurora_cluster_name}-writer-FreeableMemory${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    DBClusterIdentifier = "${each.value.aurora_cluster_name}"
    Role                = "WRITER"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// Aurora Cluster Reader FreeableMemory
resource "aws_cloudwatch_metric_alarm" "aurora_reader_freeablememory" {
  for_each = { for alarm in var.aurora_cluster_alarms : alarm.aurora_cluster_name => alarm }

  alarm_name          = "${each.value.aurora_cluster_name}-reader-FreeableMemory${var.sfx}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_reader_freeablememory_evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_reader_freeablememory_period
  statistic           = each.value.aurora_reader_freeablememory_statistic
  threshold           = each.value.aurora_reader_freeablememory_threshold
  alarm_description   = "${each.value.aurora_cluster_name}-reader-FreeableMemory${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    DBClusterIdentifier = "${each.value.aurora_cluster_name}"
    Role                = "READER"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// Aurora Instance DatabaseConnections
resource "aws_cloudwatch_metric_alarm" "aurora_databaseconnections" {
  for_each = { for alarm in var.aurora_instance_alarms : alarm.aurora_instance_name => alarm }

  alarm_name          = "${each.value.aurora_instance_name}-DatabaseConnections${var.sfx}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_databaseconnections_evaluation_periods
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_databaseconnections_period
  statistic           = each.value.aurora_databaseconnections_statistic
  threshold           = each.value.aurora_databaseconnections_threshold
  alarm_description   = "${each.value.aurora_instance_name}-DatabaseConnections${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    DBInstanceIdentifier = "${each.value.aurora_instance_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// Aurora Instance FreeLocalStorage
resource "aws_cloudwatch_metric_alarm" "aurora_freelocalstorage" {
  for_each = { for alarm in var.aurora_instance_alarms : alarm.aurora_instance_name => alarm }

  alarm_name          = "${each.value.aurora_instance_name}-FreeLocalStorage${var.sfx}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_freelocalstorage_evaluation_periods
  metric_name         = "FreeLocalStorage"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_freelocalstorage_period
  statistic           = each.value.aurora_freelocalstorage_statistic
  threshold           = each.value.aurora_freelocalstorage_threshold
  alarm_description   = "${each.value.aurora_instance_name}-FreeLocalStorage${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    DBInstanceIdentifier = "${each.value.aurora_instance_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}