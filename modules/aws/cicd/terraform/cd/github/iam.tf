/** 
# IAM Role for CodeBuild
*/
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-role${var.sfx}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-role${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "administrator_access" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

/** 
# IAM Role for CodePipeline
*/
data "aws_iam_policy_document" "codepipeline_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["codepipeline.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline-role${var.sfx}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role_policy.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline-role${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

# S3 操作用 ポリシー
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

# S3 操作 ポリシー
resource "aws_iam_policy" "codepipeline_to_s3" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline-to-s3-policy${var.sfx}"
  path   = "/"
  policy = data.aws_iam_policy_document.codepipeline_to_s3.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline-to-s3-policy${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

# S3 操作 ポリシー　アタッチ
resource "aws_iam_role_policy_attachment" "codepipeline_to_s3" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_to_s3.arn
}


# CodePipeline 実行 ポリシー
data "aws_iam_policy_document" "codepipeline_execution" {
  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuild",
      "codebuild:StartBuildBatch",
      "codebuild:StopBuild"
    ]
    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = ["*"]
  }
}

# CodePipeline 実行 ポリシー
resource "aws_iam_policy" "codepipeline_execution" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline-execution-policy${var.sfx}"
  path   = "/"
  policy = data.aws_iam_policy_document.codepipeline_execution.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline-execution-policy${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

# CodePipeline 実行 ポリシー　アタッチ
resource "aws_iam_role_policy_attachment" "codepipeline_execution" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_execution.arn
}