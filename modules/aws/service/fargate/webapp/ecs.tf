/**
# ECS
*/

# 自身の Account ID を取得
data "aws_caller_identity" "self" {}

# タスク定義テンプレート
data "template_file" "this" {
  template = file("${path.module}/task_definitions/task_definition_common.json")

  vars = {
    # common
    project      = var.common.project
    environment  = var.common.environment
    service_name = var.common.service_name
    region       = var.common.region
    sfx          = var.sfx

    # web コンテナリポジトリ
    web_repository_url = aws_ecr_repository.web.repository_url

    # app コンテナリポジトリ
    app_repository_url = aws_ecr_repository.app.repository_url

  }
}

# タスク定義
resource "aws_ecs_task_definition" "this" {
  family = "${var.common.project}-${var.common.environment}-${var.common.service_name}-task${var.sfx}"

  requires_compatibilities = ["FARGATE"]

  cpu    = var.ecs_task.cpu
  memory = var.ecs_task.memory

  network_mode = "awsvpc"

  execution_role_arn = aws_iam_role.ecs_role.arn
  task_role_arn      = aws_iam_role.ecs_role.arn

  container_definitions = data.template_file.this.rendered

  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }
}

# ECS サービス
resource "aws_ecs_service" "this" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}${var.sfx}"

  cluster          = var.ecs_service.cluster
  platform_version = var.ecs_service.platform_version

  launch_type   = var.ecs_service.launch_type
  desired_count = var.ecs_service.desired_count

  enable_execute_command = var.ecs_service.enable_execute_command

  task_definition = data.aws_ecs_task_definition.this.arn

  network_configuration {
    assign_public_ip = var.ecs_service.assign_public_ip
    subnets          = var.ecs_service.subnet_ids
    security_groups  = ["${aws_security_group.ecs.id}"]
  }

  deployment_controller {
    type = var.ecs_service.deployment_controller_type
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-web01"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer,
      desired_count
    ]
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

data "aws_ecs_task_definition" "this" {
  task_definition = aws_ecs_task_definition.this.family
}