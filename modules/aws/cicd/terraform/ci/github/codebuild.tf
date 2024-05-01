/** 
# CodeBuild
*/
resource "aws_codebuild_project" "this" {
  name         = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild${var.sfx}"
  description  = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild${var.sfx}"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type            = "GITHUB"
    location        = var.source_info.location
    git_clone_depth = var.source_info.git_clone_depth
    buildspec       = var.source_info.buildspec
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
      group_name = aws_cloudwatch_log_group.this.name
    }
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_codebuild_webhook" "this" {
  project_name = aws_codebuild_project.this.name
  build_type   = "BUILD"

  dynamic "filter_group" {
    for_each = var.filter_groups

    content {
      filter {
        exclude_matched_pattern = false
        pattern                 = filter_group.value.event_pattern
        type                    = "EVENT"
      }
      filter {
        exclude_matched_pattern = false
        pattern                 = filter_group.value.file_pattern
        type                    = "FILE_PATH"
      }
    }
  }
}