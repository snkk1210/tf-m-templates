/**
# ECS
*/

// 自身の Account ID を取得
data "aws_caller_identity" "self" {}

// タスク定義テンプレート
data "template_file" "task" {
  template = file("${path.module}/task_definitions/task_definition_common.json")

  vars = {
    // common
    project      = var.common.project
    environment  = var.common.environment
    service_name = var.common.service_name
    region       = var.common.region

    // コンテナリポジトリ
    repository_url = aws_ecr_repository.this.repository_url
  }
}

// タスク定義
resource "aws_ecs_task_definition" "this" {
  family = "${var.common.project}-${var.common.environment}-${var.common.service_name}-task"

  requires_compatibilities = ["FARGATE"]

  cpu    = var.ecs_task.cpu
  memory = var.ecs_task.memory

  network_mode = var.ecs_task.network_mode

  execution_role_arn = aws_iam_role.ecs_role.arn
  task_role_arn      = aws_iam_role.ecs_role.arn

  container_definitions = data.template_file.task.rendered

  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }
}

// ECS サービス
resource "aws_ecs_service" "this" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}"

  cluster          = var.ecs_cluster_id
  platform_version = var.ecs_service.platform_version

  launch_type   = var.ecs_service.launch_type
  desired_count = var.ecs_service.desired_count

  enable_execute_command = true

  task_definition = aws_ecs_task_definition.this.arn

  network_configuration {
    assign_public_ip = false
    subnets          = var.ecs_subnet_ids
    security_groups  = ["${aws_security_group.ecs.id}"]
  }

  deployment_controller {
    type = var.ecs_service.deployment_controller_type
  }

  lifecycle {
    ignore_changes = [
      platform_version,
      task_definition,
      load_balancer,
      desired_count
    ]
  }
}