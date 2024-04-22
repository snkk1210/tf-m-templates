/**
# CodeBuild
*/
resource "aws_codebuild_project" "plan" {
  name         = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-plan-codebuild${var.sfx}"
  description  = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-plan-codebuild${var.sfx}"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.plan_buildspec
  }

  environment {
    compute_type                = var.plan_environment.compute_type
    image                       = var.plan_environment.image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.plan_environment.privileged_mode

    dynamic "environment_variable" {
      for_each = var.plan_environment_variable.variables

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.plan.name
    }
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-plan-codebuild${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_codebuild_project" "apply" {
  name         = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-apply-codebuild${var.sfx}"
  description  = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-apply-codebuild${var.sfx}"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.apply_buildspec
  }

  environment {
    compute_type                = var.apply_environment.compute_type
    image                       = var.apply_environment.image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.apply_environment.privileged_mode

    dynamic "environment_variable" {
      for_each = var.apply_environment_variable.variables

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.apply.name
    }
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-apply-codebuild${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}