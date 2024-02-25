/**
# CodeBuild
*/
resource "aws_codebuild_project" "this" {
  name         = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-project${var.sfx}"
  description  = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-project${var.sfx}"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type            = "GITHUB"
    location        = var.location
    git_clone_depth = var.git_clone_depth
    buildspec       = var.buildspec
  }

  environment {
    compute_type                = var.compute_type
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

resource "aws_codebuild_webhook" "this" {
  project_name = aws_codebuild_project.this.name

  filter_group {
    filter {
      pattern = "PULL_REQUEST_CREATED"
      type    = "EVENT"
    }
  }

  filter_group {
    filter {
      pattern = "PULL_REQUEST_UPDATED"
      type    = "EVENT"
    }
  }

  filter_group {
    filter {
      pattern = "PULL_REQUEST_REOPENED"
      type    = "EVENT"
    }
  }
}