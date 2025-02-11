/** 
# CodeDeploy
*/
resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codedeploy${var.sfx}"
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.common.project}-${var.common.environment}-${var.common.service_name}${var.sfx}"
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
      termination_wait_time_in_minutes = 1
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = regex("cluster/(.+)", var.ecs_service.cluster)[0]
    service_name = aws_ecs_service.this.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.https.arn]
      }

      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }
}

/** 
# IAM ( CodeDeploy )
*/
resource "aws_iam_role" "codedeploy_role" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codedeploy-role${var.sfx}"
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

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codedeploy-role${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

data "aws_iam_policy_document" "codedeploy_execution" {
  statement {
    actions = [
      "ecs:DescribeServices",
      "ecs:CreateTaskSet",
      "ecs:UpdateServicePrimaryTaskSet",
      "ecs:DeleteTaskSet",
    ]
    resources = [
      var.ecs_service.cluster,
      aws_ecs_service.this.id,
      "${aws_ecs_task_definition.this.arn_without_revision}:*",
      "arn:aws:ecs:${var.common.region}:${data.aws_caller_identity.self.account_id}:task-set/${regex("cluster/(.+)", var.ecs_service.cluster)[0]}/*",
    ]
  }

  statement {
    actions = [
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DescribeRules",
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "iam:PassRole"
    ]
    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
    resources = [
      aws_iam_role.ecs_role.arn,
    ]
  }
}

resource "aws_iam_policy" "codedeploy_execution" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codedeploy-execution-policy${var.sfx}"
  path   = "/"
  policy = data.aws_iam_policy_document.codedeploy_execution.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codedeploy-execution-policy${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy_execution" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = aws_iam_policy.codedeploy_execution.arn
}