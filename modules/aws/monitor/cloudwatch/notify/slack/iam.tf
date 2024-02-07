/** 
# IAM For CloudWatch Alarm Lambda
*/

// Lambda role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.common.project}-${var.common.environment}-cwalarm-notify-lambda-role${var.sfx}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-cwalarm-notify-lambda-role${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

// Lambda 基本実行 ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// SSM パラメータ 読み込み ポリシー
data "aws_iam_policy_document" "lambda_to_ssm" {
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]
    resources = [
      "*"
    ]
  }
}

// SSM パラメータ 読み込み ポリシー
resource "aws_iam_policy" "lambda_to_ssm" {
  name = "${var.common.project}-${var.common.environment}-cwalarm-notify-lambda-policy${var.sfx}"
  path = "/"
  policy = data.aws_iam_policy_document.lambda_to_ssm.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-cwalarm-notify-lambda-policy${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

// SSM パラメータ 読み込み ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "lambda_to_ssm" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_to_ssm.arn
}