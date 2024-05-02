/**
# CodeDeploy
*/
resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codedeploy${var.sfx}"
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.common.project}-${var.common.environment}-${var.common.service_name}"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_service.cluster_name
    service_name = var.ecs_service.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.lb_info.prod_traffic_route_listener_arns
      }

      target_group {
        name = var.lb_info.blue_target_group
      }

      target_group {
        name = var.lb_info.green_target_group
      }
    }
  }
}