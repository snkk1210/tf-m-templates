/**
# CodeBuild
*/
resource "aws_codebuild_project" "this" {
  name         = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-project"
  description  = "${var.common.service_name} stage1 CodeBuild Project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type      = "GITHUB"
    location = var.location
    git_clone_depth = var.git_clone_depth
    buildspec = var.buildspec
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment.variables

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  vpc_config {
    vpc_id = var.vpc_id

    subnets = var.codebuild_subnet_ids

    security_group_ids = ["${aws_security_group.codebuild.id}"]
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild.name
    }
  }

  lifecycle {
    ignore_changes = [
      //environment["environment_variable"],
    ]
  }
}


/**
# Security Group for CodeBuild
*/

// CodeBuild Security Group
resource "aws_security_group" "codebuild" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-sg"
  description = "Security group for CodeBuild"
  vpc_id      = var.vpc_id
  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-sg"
    Environment = var.common.environment
  }
}

resource "aws_security_group_rule" "codebuild_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.codebuild.id
}