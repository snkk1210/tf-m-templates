/**
# CodeDeploy
*/
resource "aws_codedeploy_app" "app" {
  compute_platform = "ECS"
  name             = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codedeploy-app"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = aws_codedeploy_app.app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = var.common.service_name
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
        listener_arns = var.prod_traffic_route_listener_arns
      }

      // Blue Target Group
      target_group {
        name = var.blue_target_group
      }

      // Green Target Group
      target_group {
        name = var.green_target_group
      }

    }
  }
}

/**
# CodeDeploy IAM
*/

// CodeDeploy role
resource "aws_iam_role" "codedeploy_role" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codedeploy-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

// CodeDeploy 実行 ポリシー
data "aws_iam_policy_document" "codedeploy_execution" {
  statement {
    actions = [
      "iam:PassRole",
      "ecs:DescribeServices",
      "ecs:CreateService",
      "ecs:UpdateService",
      "ecs:DeleteService",
      "ecs:CreateTaskSet",
      "ecs:UpdateServicePrimaryTaskSet",
      "ecs:DeleteTaskSet",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:ModifyRule",
      "lambda:InvokeFunction",
      "cloudwatch:DescribeAlarms",
      "sns:Publish",
      "s3:GetObject",
      "s3:GetObjectMetadata",
      "s3:GetObjectVersion"
    ]

    resources = [
      "*",
    ]

  }
}

// CodeDeploy 実行 ポリシー
resource "aws_iam_policy" "codedeploy_execution" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codedeploy-execution-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.codedeploy_execution.json
}

// CodeDeploy 実行 ポリシー　アタッチ
resource "aws_iam_role_policy_attachment" "codedeploy_execution" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = aws_iam_policy.codedeploy_execution.arn
}