resource "aws_autoscaling_policy" "target_tracking_cpuutilization" {
  count = var.enable_tracking_cpuutilization ? 1 : 0

  name                   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-cpu-asg-policy"
  autoscaling_group_name = aws_eks_node_group.this.resources[0].autoscaling_groups[0].name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.target_value
  }
}