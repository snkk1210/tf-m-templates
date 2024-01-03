/**
# CodePipeline
*/
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifact.id
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
    name = "Stage1_Build"

    action {
      name             = "Stage1_Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["stage1_build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.stage1.name
      }
    }
  }

  stage {
    name = "approve"

    action {
      name     = "approve"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Stage2_Build"

    action {
      name             = "Stage2_Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["stage2_build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.stage2.name
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