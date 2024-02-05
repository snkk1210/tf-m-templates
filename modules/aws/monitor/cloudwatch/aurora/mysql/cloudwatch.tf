/** 
# NOTE: CloudWatch Alarm Aurora
*/

// Aurora Cluster Writer CPUUtilization 
resource "aws_cloudwatch_metric_alarm" "aurora_writer_cpuutilization" {
  for_each = { for cluster in var.aurora_cluster_alarm : cluster.aurora_cluster_name => cluster }

  alarm_name          = "${each.value.aurora_cluster_name}-writer-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_writer_cpuutilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_writer_cpuutilization_period
  statistic           = each.value.aurora_writer_cpuutilization_statistic
  threshold           = each.value.aurora_writer_cpuutilization_threshold
  alarm_description   = "${each.value.aurora_cluster_name}-writer-CPUUtilization"

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
  for_each = { for cluster in var.aurora_cluster_alarm : cluster.aurora_cluster_name => cluster }

  alarm_name          = "${each.value.aurora_cluster_name}-reader-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_reader_cpuutilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_reader_cpuutilization_period
  statistic           = each.value.aurora_reader_cpuutilization_statistic
  threshold           = each.value.aurora_reader_cpuutilization_threshold
  alarm_description   = "${each.value.aurora_cluster_name}-reader-CPUUtilization"

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
  for_each = { for cluster in var.aurora_cluster_alarm : cluster.aurora_cluster_name => cluster }

  alarm_name          = "${each.value.aurora_cluster_name}-writer-FreeableMemory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_writer_freeablememory_evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_writer_freeablememory_period
  statistic           = each.value.aurora_writer_freeablememory_statistic
  threshold           = each.value.aurora_writer_freeablememory_threshold
  alarm_description   = "${each.value.aurora_cluster_name}-writer-FreeableMemory"

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
  for_each = { for cluster in var.aurora_cluster_alarm : cluster.aurora_cluster_name => cluster }

  alarm_name          = "${each.value.aurora_cluster_name}-reader-FreeableMemory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_reader_freeablememory_evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_reader_freeablememory_period
  statistic           = each.value.aurora_reader_freeablememory_statistic
  threshold           = each.value.aurora_reader_freeablememory_threshold
  alarm_description   = "${each.value.aurora_cluster_name}-reader-FreeableMemory"

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

// Aurora Cluster AuroraVolumeBytesLeftTotal 
resource "aws_cloudwatch_metric_alarm" "aurora_auroravolumebyteslefttotal" {
  for_each = { for cluster in var.aurora_cluster_alarm : cluster.aurora_cluster_name => cluster }

  alarm_name          = "${each.value.aurora_cluster_name}-AuroraVolumeBytesLeftTotal"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_auroravolumebyteslefttotal_evaluation_periods
  metric_name         = "AuroraVolumeBytesLeftTotal"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_auroravolumebyteslefttotal_period
  statistic           = each.value.aurora_auroravolumebyteslefttotal_statistic
  threshold           = each.value.aurora_auroravolumebyteslefttotal_threshold
  alarm_description   = "${each.value.aurora_cluster_name}-AuroraVolumeBytesLeftTotal"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    DBClusterIdentifier = "${each.value.aurora_cluster_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// Aurora Cluster DMLLatency
resource "aws_cloudwatch_metric_alarm" "aurora_dmllatency" {
  for_each = { for cluster in var.aurora_cluster_alarm : cluster.aurora_cluster_name => cluster }

  alarm_name          = "${each.value.aurora_cluster_name}-DMLLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_dmllatency_evaluation_periods
  metric_name         = "DMLLatency"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_dmllatency_period
  statistic           = each.value.aurora_dmllatency_statistic
  threshold           = each.value.aurora_dmllatency_threshold
  alarm_description   = "${each.value.aurora_cluster_name}-DMLLatency"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    DBClusterIdentifier = "${each.value.aurora_cluster_name}"
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
  for_each = { for instance in var.aurora_instance_alarm : instance.aurora_instance_name => instance }

  alarm_name          = "${each.value.aurora_instance_name}-DatabaseConnections"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_databaseconnections_evaluation_periods
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_databaseconnections_period
  statistic           = each.value.aurora_databaseconnections_statistic
  threshold           = each.value.aurora_databaseconnections_threshold
  alarm_description   = "${each.value.aurora_instance_name}-DatabaseConnections"

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
  for_each = { for instance in var.aurora_instance_alarm : instance.aurora_instance_name => instance }

  alarm_name          = "${each.value.aurora_instance_name}-FreeLocalStorage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.aurora_freelocalstorage_evaluation_periods
  metric_name         = "FreeLocalStorage"
  namespace           = "AWS/RDS"
  period              = each.value.aurora_freelocalstorage_period
  statistic           = each.value.aurora_freelocalstorage_statistic
  threshold           = each.value.aurora_freelocalstorage_threshold
  alarm_description   = "${each.value.aurora_instance_name}-FreeLocalStorage"

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