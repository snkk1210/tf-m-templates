/**
# CodeBuild
*/
resource "aws_codebuild_project" "stage1" {
  name         = "${var.common.project}-${var.common.environment}-${var.common.service_name}-stage1-codebuild-project"
  description  = "${var.common.service_name} stage1 CodeBuild Project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.stage1_buildspec
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.stage1_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.stage1_privileged_mode

    dynamic "environment_variable" {
      for_each = var.stage1_environment.variables

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

resource "aws_codebuild_project" "stage2" {
  name         = "${var.common.project}-${var.common.environment}-${var.common.service_name}-stage2-codebuild-project"
  description  = "${var.common.service_name} stage2 CodeBuild Project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.stage2_buildspec
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.stage2_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.stage2_privileged_mode

    dynamic "environment_variable" {
      for_each = var.stage2_environment.variables

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

// CodeBuild 実行 ポリシー
resource "aws_iam_policy" "codebuild_execution" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-codebuild-execution-policy"
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