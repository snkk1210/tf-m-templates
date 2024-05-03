/**
# CodePipeline
*/
resource "aws_codepipeline" "this" {
  name          = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline${var.sfx}"
  role_arn      = aws_iam_role.codepipeline_role.arn
  pipeline_type = "V2"

  artifact_store {
    location = aws_s3_bucket.this.id
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
      output_artifacts = ["source_output"]

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
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.this.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName                = aws_codedeploy_app.this.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.this.deployment_group_name
        TaskDefinitionTemplateArtifact = "build_output"
        TaskDefinitionTemplatePath     = var.task_definition_template_path
        AppSpecTemplateArtifact        = "build_output"
        AppSpecTemplatePath            = var.app_spec_template_path
      }
    }
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}