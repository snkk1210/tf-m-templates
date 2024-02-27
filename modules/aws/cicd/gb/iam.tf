/**
# IAM Role for CodeBuild
*/

// CodeBuild Assume role
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type        = "Service"
    }
  }
}

// CodeBuild role
resource "aws_iam_role" "codebuild_role" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-role${var.sfx}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

// CodeBuild 実行 ポリシー
data "aws_iam_policy_document" "codebuild_execution" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "codebuild:StopBuild",
    ]
    resources = ["*"]
  }
}

// CodeBuild 実行 ポリシー
resource "aws_iam_policy" "codebuild_execution" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-execution-policy${var.sfx}"
  path   = "/"
  policy = data.aws_iam_policy_document.codebuild_execution.json
}

// CodeBuild 実行 ポリシー　アタッチ
resource "aws_iam_role_policy_attachment" "codebuild_execution" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_execution.arn
}

// AdministratorAccess ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "administrator_access" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}