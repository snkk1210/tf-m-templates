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

    // web コンテナリポジトリ
    web_repository_url = aws_ecr_repository.web.repository_url
    web_container_port = var.ecs_task_web.container_port

    // app コンテナリポジトリ
    app_repository_url = aws_ecr_repository.app.repository_url

  }
}

// タスク定義
resource "aws_ecs_task_definition" "main" {
  family = "${var.common.project}-${var.common.service_name}-${var.common.environment}-task"

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
resource "aws_ecs_service" "main" {
  name = "${var.common.project}-${var.common.service_name}-${var.common.environment}"

  cluster          = var.ecs_cluster_id
  platform_version = var.ecs_service.platform_version

  launch_type   = var.ecs_service.launch_type
  desired_count = var.ecs_service.desired_count

  enable_execute_command = true

  task_definition = aws_ecs_task_definition.main.arn

  network_configuration {
    assign_public_ip = false
    subnets          = var.subnet_ids
    security_groups  = ["${aws_security_group.ecs.id}"]
  }

  deployment_controller {
    type = var.ecs_service.deployment_controller_type
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "${var.common.project}-${var.common.service_name}-${var.common.environment}-web-container"
    container_port   = var.ecs_task_web.container_port
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