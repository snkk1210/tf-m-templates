/**
# IAM
*/

// ECS role
resource "aws_iam_role" "ecs_role" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-role${var.sfx}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-role${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

// Task 実行用 ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// ECR 読み込み ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "ecs_to_ecr" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

// SSM パラメータ 読み込み ポリシー
resource "aws_iam_policy" "ecs_to_ssm" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-to-ssm-policy${var.sfx}"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ],
      "Resource": "*"
    }
  ]
}
EOF

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-to-ssm-policy${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

// SSM パラメータ 読み込み ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "ecs_to_ssm" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.ecs_to_ssm.arn
}

// S3 接続 ポリシー アタッチ
data "aws_iam_policy_document" "ecs_to_s3" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::*",
    ]

  }
}

// S3 接続 ポリシー
resource "aws_iam_policy" "ecs_to_s3" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-to-s3-policy${var.sfx}"
  path   = "/"
  policy = data.aws_iam_policy_document.ecs_to_s3.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-to-s3-policy${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

// S3 接続 ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "ecs_to_s3" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.ecs_to_s3.arn
}

// SSMMESSAGES 接続 ポリシー アタッチ
data "aws_iam_policy_document" "ecs_to_ssmmessages" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = ["*"]

  }
}

// SSMMESSAGES 接続 ポリシー
resource "aws_iam_policy" "ecs_to_ssmmessages" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-to-ssmmessages-policy${var.sfx}"
  path   = "/"
  policy = data.aws_iam_policy_document.ecs_to_ssmmessages.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-ecs-to-ssmmessages-policy${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

// SSMMESSAGES 接続 ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "ecs_to_ssmmessages" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.ecs_to_ssmmessages.arn
}