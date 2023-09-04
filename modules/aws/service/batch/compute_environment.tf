/**
# Batch Compute Environment
*/
resource "aws_batch_compute_environment" "batch_environment" {
  compute_environment_name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-batch-environment"

  compute_resources {
    max_vcpus = var.max_vcpus

    security_group_ids = [aws_security_group.fargate.id, ]

    subnets = var.batch_subnet_ids

    type = "FARGATE"
  }

  service_role = aws_iam_role.batch_environment_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.batch_environment]
}

/**
# Batch Compute Environment IAM
*/

// Batch 環境 role
resource "aws_iam_role" "batch_environment_role" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-batch-environment-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "batch_environment" {
  role       = aws_iam_role.batch_environment_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}