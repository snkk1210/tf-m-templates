/**
# CodePipeline
*/
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.artifact_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        RepositoryName       = aws_codecommit_repository.repository.tags_all["Name"]
        BranchName           = "${var.reference_name}"
        PollForSourceChanges = false
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
        ProjectName = aws_codebuild_project.codebuild_project.name
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
        ApplicationName                = aws_codedeploy_app.app.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
        TaskDefinitionTemplateArtifact = "build_output"
        TaskDefinitionTemplatePath     = var.task_definition_template_path
        AppSpecTemplateArtifact        = "build_output"
        AppSpecTemplatePath            = var.app_spec_template_path
      }
    }
  }
}

/**
# IAM Role for CodePipeline
*/

// CodePipeline role
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

// S3 操作用 ポリシー
data "aws_iam_policy_document" "codepipeline_to_s3" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::*",
    ]

  }
}

// S3 操作 ポリシー
resource "aws_iam_policy" "codepipeline_to_s3" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codepipeline-to-s3-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.codepipeline_to_s3.json
}

// S3 操作 ポリシー　アタッチ
resource "aws_iam_role_policy_attachment" "codepipeline_to_s3" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_to_s3.arn
}


// CodePipeline 実行 ポリシー
data "aws_iam_policy_document" "codepipeline_execution" {
  statement {
    actions = [
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
      "codecommit:CancelUploadArchive"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:StopBuild"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:PassRole"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService"
    ]

    resources = [
      "*",
    ]
  }

}

// CodePipeline 実行 ポリシー
resource "aws_iam_policy" "codepipeline_execution" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codepipeline-execution-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.codepipeline_execution.json
}

// CodePipeline 実行 ポリシー　アタッチ
resource "aws_iam_role_policy_attachment" "codepipeline_execution" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_execution.arn
}