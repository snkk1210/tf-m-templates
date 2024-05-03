/** 
# CodeBuild
*/
resource "aws_codebuild_project" "this" {
  name         = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild${var.sfx}"
  description  = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild${var.sfx}"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec
  }

  environment {
    compute_type                = var.environment.compute_type
    image                       = var.environment.image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.environment.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment_variable.variables

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild.name
    }
  }

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.codebuild_subnet_ids
    security_group_ids = ["${aws_security_group.codebuild.id}"]
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_security_group" "codebuild" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-sg${var.sfx}"
  description = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-sg${var.sfx}"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-sg${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
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