/**
# IAM Role for CodeBuild
*/
# CodeBuild role
resource "aws_iam_role" "codebuild_role" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-role${var.sfx}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-role${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

# CodeBuild 実行 ポリシー
data "aws_iam_policy_document" "codebuild_execution" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "codebuild:StopBuild",
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = ["*"]
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
    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:*"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = ["*"]
  }

  statement {
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

# CodeBuild 実行 ポリシー
resource "aws_iam_policy" "codebuild_execution" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-execution-policy${var.sfx}"
  path   = "/"
  policy = data.aws_iam_policy_document.codebuild_execution.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-execution-policy${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

# CodeBuild 実行 ポリシー　アタッチ
resource "aws_iam_role_policy_attachment" "codebuild_execution" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_execution.arn
}

/**
# IAM Role for CodeDeploy
*/
# CodeDeploy role
resource "aws_iam_role" "codedeploy_role" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codedeploy-role${var.sfx}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codedeploy-role${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

# CodeDeploy 実行 ポリシー
data "aws_iam_policy_document" "codedeploy_execution" {
  statement {
    actions = [
      "iam:PassRole",
      "ecs:DescribeServices",
      "ecs:CreateService",
      "ecs:UpdateService",
      "ecs:DeleteService",
      "ecs:CreateTaskSet",
      "ecs:UpdateServicePrimaryTaskSet",
      "ecs:DeleteTaskSet",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:ModifyRule",
      "lambda:InvokeFunction",
      "cloudwatch:DescribeAlarms",
      "sns:Publish",
      "s3:GetObject",
      "s3:GetObjectMetadata",
      "s3:GetObjectVersion"
    ]
    resources = [
      "*",
    ]
  }
}

# CodeDeploy 実行 ポリシー
resource "aws_iam_policy" "codedeploy_execution" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codedeploy-execution-policy${var.sfx}"
  path   = "/"
  policy = data.aws_iam_policy_document.codedeploy_execution.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codedeploy-execution-policy${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

# CodeDeploy 実行 ポリシー　アタッチ
resource "aws_iam_role_policy_attachment" "codedeploy_execution" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = aws_iam_policy.codedeploy_execution.arn
}

/**
# IAM Role for CodePipeline
*/
# CodePipeline role
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codepipeline-role${var.sfx}"

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
      "*",
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
      "codestar-connections:UseConnection"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:StopBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch"
    ]
    resources = [
      "*"
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
      "*"
    ]
  }

  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "*"
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
      "*"
    ]
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