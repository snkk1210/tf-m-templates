/** 
# NOTE: CloudWatch Alarm Fargate
*/

// Fargate CPUUtilization
resource "aws_cloudwatch_metric_alarm" "fargate_cpuutilization" {
  for_each = { for service in var.fargate_service_alarm : service.fargate_name => service }

  alarm_name          = "${each.value.fargate_name}-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.fargate_cpuutilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = each.value.fargate_cpuutilization_period
  statistic           = each.value.fargate_cpuutilization_statistic
  threshold           = each.value.fargate_cpuutilization_threshold
  alarm_description   = "${each.value.fargate_name}-CPUUtilization"

  alarm_actions             = var.notify_sns_topic_arn
  ok_actions                = var.notify_sns_topic_arn
  insufficient_data_actions = []

  dimensions = {
    ClusterName = "${each.value.cluster_name}"
    ServiceName = "${each.value.fargate_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// Fargate MemoryUtilization
resource "aws_cloudwatch_metric_alarm" "fargate_memoryutilization" {
  for_each = { for service in var.fargate_service_alarm : service.fargate_name => service }

  alarm_name          = "${each.value.fargate_name}-MemoryUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.fargate_memoryutilization_evaluation_periods
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = each.value.fargate_memoryutilization_period
  statistic           = each.value.fargate_memoryutilization_statistic
  threshold           = each.value.fargate_memoryutilization_threshold
  alarm_description   = "${each.value.fargate_name}-MemoryUtilization"

  alarm_actions             = var.notify_sns_topic_arn
  ok_actions                = var.notify_sns_topic_arn
  insufficient_data_actions = []

  dimensions = {
    ClusterName = "${each.value.cluster_name}"
    ServiceName = "${each.value.fargate_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

// Fargate RunningTaskCount
resource "aws_cloudwatch_metric_alarm" "fargate_runningtaskcount" {
  for_each = { for service in var.fargate_service_alarm : service.fargate_name => service }

  alarm_name          = "${each.value.fargate_name}-RunningTaskCount"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = each.value.fargate_runningtaskcount_evaluation_periods
  metric_name         = "RunningTaskCount"
  namespace           = "ECS/ContainerInsights"
  period              = each.value.fargate_runningtaskcount_period
  statistic           = each.value.fargate_runningtaskcount_statistic
  threshold           = each.value.fargate_runningtaskcount_threshold
  alarm_description   = "${each.value.fargate_name}-RunningTaskCount"
  actions_enabled     = each.value.fargate_runningtaskcount_actions_enabled

  alarm_actions             = var.notify_sns_topic_arn
  ok_actions                = var.notify_sns_topic_arn
  insufficient_data_actions = []

  dimensions = {
    ClusterName = "${each.value.cluster_name}"
    ServiceName = "${each.value.fargate_name}"
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      alarm_description
    ]
  }
}

