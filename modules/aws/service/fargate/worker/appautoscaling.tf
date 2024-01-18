/**
# AutoScaling
*/
resource "aws_appautoscaling_target" "this" {
  max_capacity       = var.appautoscaling_target.max_capacity
  min_capacity       = var.appautoscaling_target.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.this.name}"
  scalable_dimension = var.appautoscaling_target.scalable_dimension
  service_namespace  = var.appautoscaling_target.service_namespace

  lifecycle {
    ignore_changes = [
      max_capacity,
      min_capacity
    ]
  }
}

resource "aws_appautoscaling_policy" "policy" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-scaling-policy"
  policy_type        = var.appautoscaling_policy.policy_type
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {

    customized_metric_specification {
      metric_name = "CPUUtilization"
      namespace   = "AWS/ECS"
      statistic   = var.appautoscaling_policy.statistic
      unit        = "Percent"

      dimensions {
        name  = "ServiceName"
        value = "${var.common.project}-${var.common.environment}-${var.common.service_name}"
      }
      dimensions {
        name  = "ClusterName"
        value = "${var.common.project}-${var.common.environment}-cluster"
      }
    }

    target_value       = var.appautoscaling_policy.target_value
    disable_scale_in   = var.appautoscaling_policy.disable_scale_in
    scale_in_cooldown  = var.appautoscaling_policy.scale_in_cooldown
    scale_out_cooldown = var.appautoscaling_policy.scale_out_cooldown
  }
}