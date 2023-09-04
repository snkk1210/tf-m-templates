/**
# Job Definition For Batch
*/
data "aws_caller_identity" "self" {}

/**
# IAM Role For Job 定義
*/

// Batch role
resource "aws_iam_role" "ecs_batch_job_role" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-batch-job-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

// Batch Assume role
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

// ECR 読み込み ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "batch_to_ecr" {
  role       = aws_iam_role.ecs_batch_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

// SSM 参照 ポリシー
resource "aws_iam_policy" "batch_to_ssm" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-batch-to-ssm-policy"
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
}

resource "aws_iam_role_policy_attachment" "batch_to_ssm" {
  role       = aws_iam_role.ecs_batch_job_role.name
  policy_arn = aws_iam_policy.batch_to_ssm.arn
}

// CloudWatch Logs 操作 ポリシー
data "aws_iam_policy_document" "batch_to_cw" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

// CloudWatch Logs 操作 ポリシー
resource "aws_iam_policy" "batch_to_cw" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-batch-to-cw-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.batch_to_cw.json
}

// CloudWatch Logs 操作 ポリシー
resource "aws_iam_role_policy_attachment" "batch_to_cw" {
  role       = aws_iam_role.ecs_batch_job_role.name
  policy_arn = aws_iam_policy.batch_to_cw.arn
}

/**
# Job 定義
*/

// Job 定義
resource "aws_batch_job_definition" "batch_job_definition" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-batch-job-definition"
  type = "container"

  timeout {
    attempt_duration_seconds = var.timeout_sec
  }

  platform_capabilities = [
    "FARGATE",
  ]
  container_properties = data.template_file.batch_definition.rendered
}

// Job 定義テンプレート
data "template_file" "batch_definition" {
  template = file("${path.module}/task_definitions/task_definition_batch.json")

  vars = {

    // CPU
    vcpu = var.batch_definition.vcpu

    // メモリー
    memory = var.batch_definition.memory

    // command
    command = var.command

    // ジョブロール
    aws_iam_role_ecs_job_role_arn = aws_iam_role.ecs_batch_job_role.arn

    // タスク実行 ロール
    aws_iam_role_ecs_job_execution_role_arn = aws_iam_role.ecs_batch_job_role.arn

    // ECR リポジトリ
    batch_repository_url = aws_ecr_repository.batch

    // リージョン
    region = var.common.region

    // 環境
    environment = var.common.environment

    // Batch 名
    service_name = var.common.service_name
  }
}