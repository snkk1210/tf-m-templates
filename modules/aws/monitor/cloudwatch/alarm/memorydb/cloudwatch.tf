/** 
# CloudWatch Alarm MemoryDB for Redis
*/

// MemoryDB for Redis CPUUtilization 
resource "aws_cloudwatch_metric_alarm" "memorydb_cpuutilization" {
  for_each = { for alarm in var.memorydb_cluster_alarms : alarm.memorydb_cluster_name => alarm }

  alarm_name          = "${each.value.memorydb_cluster_name}-CPUUtilization${var.sfx}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.memorydb_cpuutilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/MemoryDB"
  period              = each.value.memorydb_cpuutilization_period
  statistic           = each.value.memorydb_cpuutilization_statistic
  threshold           = each.value.memorydb_cpuutilization_threshold
  alarm_description   = "${each.value.memorydb_cluster_name}-CPUUtilization${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    ClusterName = "${each.value.memorydb_cluster_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// MemoryDB for Redis FreeableMemory
resource "aws_cloudwatch_metric_alarm" "memorydb_freeablememory" {
  for_each = { for alarm in var.memorydb_cluster_alarms : alarm.memorydb_cluster_name => alarm }

  alarm_name          = "${each.value.memorydb_cluster_name}-FreeableMemory${var.sfx}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = each.value.memorydb_freeablememory_evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/MemoryDB"
  period              = each.value.memorydb_freeablememory_period
  statistic           = each.value.memorydb_freeablememory_statistic
  threshold           = each.value.memorydb_freeablememory_threshold
  alarm_description   = "${each.value.memorydb_cluster_name}-FreeableMemory${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    ClusterName = "${each.value.memorydb_cluster_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// MemoryDB for Redis SwapUsage
resource "aws_cloudwatch_metric_alarm" "memorydb_swapusage" {
  for_each = { for alarm in var.memorydb_cluster_alarms : alarm.memorydb_cluster_name => alarm }

  alarm_name          = "${each.value.memorydb_cluster_name}-SwapUsage${var.sfx}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.memorydb_swapusage_evaluation_periods
  metric_name         = "SwapUsage"
  namespace           = "AWS/MemoryDB"
  period              = each.value.memorydb_swapusage_period
  statistic           = each.value.memorydb_swapusage_statistic
  threshold           = each.value.memorydb_swapusage_threshold
  alarm_description   = "${each.value.memorydb_cluster_name}-SwapUsage${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    ClusterName = "${each.value.memorydb_cluster_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// MemoryDB for Redis Evictions
resource "aws_cloudwatch_metric_alarm" "memorydb_evictions" {
  for_each = { for alarm in var.memorydb_cluster_alarms : alarm.memorydb_cluster_name => alarm }

  alarm_name          = "${each.value.memorydb_cluster_name}-Evictions${var.sfx}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.memorydb_evictions_evaluation_periods
  metric_name         = "Evictions"
  namespace           = "AWS/MemoryDB"
  period              = each.value.memorydb_evictions_period
  statistic           = each.value.memorydb_evictions_statistic
  threshold           = each.value.memorydb_evictions_threshold
  alarm_description   = "${each.value.memorydb_cluster_name}-Evictions${var.sfx}"

  alarm_actions             = var.action.alarm
  ok_actions                = var.action.ok
  insufficient_data_actions = var.action.insufficient

  dimensions = {
    ClusterName = "${each.value.memorydb_cluster_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}