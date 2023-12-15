/**
# CodeBuild
*/
resource "aws_codebuild_project" "this" {
  name         = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-project"
  description  = "${var.common.service_name} CodeBuild Project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./deploy_scripts/buildspec.yml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = var.environment.variables

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  vpc_config {
    vpc_id = var.vpc_id

    subnets = var.codebuild_subnet_ids

    security_group_ids = ["${aws_security_group.codebuild.id}"]
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

/**
# Security Group for CodeBuild
*/

// CodeBuild Security Group
resource "aws_security_group" "codebuild" {
  name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-sg"
  description = "Security group for CodeBuild"
  vpc_id      = var.vpc_id
  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-sg"
    Environment = var.common.environment
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
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-role"
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
      "codecommit:GitPull"
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

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:CreateNetworkInterfacePermission"
    ]
    resources = ["*"]
  }

}

resource "aws_iam_policy" "codebuild_execution" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-execution-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.codebuild_execution.json
}

resource "aws_iam_role_policy_attachment" "codebuild_execution" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_execution.arn
}

// CodeBuild EKS 操作 ポリシー
data "aws_iam_policy_document" "codebuild_to_eks" {
  statement {
    actions = [
      "eks:*",
      "ecr:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "codebuild_to_eks" {
  name   = "${var.common.project}-${var.common.environment}-codebuild-to-eks-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.codebuild_to_eks.json
}

resource "aws_iam_role_policy_attachment" "codebuild_to_eks" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_to_eks.arn
}

// CodeBuild ECR 操作 ポリシー
resource "aws_iam_role_policy_attachment" "codebuild_to_ecr" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

