/**
# CodePipeline
*/
resource "aws_codepipeline" "this" {
  name          = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline${var.sfx}"
  role_arn      = aws_iam_role.codepipeline_role.arn
  pipeline_type = "V2"

  variable {
    name          = "TARGET_DIR"
    default_value = var.target_dir
    description   = "Directory where Terraform is run."
  }

  artifact_store {
    location = var.artifact_s3_bucket_id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      namespace        = "SourceVariables"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn        = var.codestarconnections_connection_arn
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        FullRepositoryId     = var.repository_name
        BranchName           = "${var.branch_name}"
        DetectChanges        = false
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name             = "Plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["plan_build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.plan.name
        EnvironmentVariables = jsonencode([
          {
            type  = "PLAINTEXT"
            name  = "APPLY"
            value = "false"
          },
          {
            type  = "PLAINTEXT"
            name  = "TARGET_DIR"
            value = "#{variables.TARGET_DIR}"
          }
        ])
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Apply"

    action {
      name             = "Apply"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["plan_build_output"]
      output_artifacts = ["apply_build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.apply.name
        EnvironmentVariables = jsonencode([
          {
            type  = "PLAINTEXT"
            name  = "APPLY"
            value = "true"
          },
          {
            type  = "PLAINTEXT"
            name  = "TARGET_DIR"
            value = "#{variables.TARGET_DIR}"
          }
        ])
      }
    }
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}