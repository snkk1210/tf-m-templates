/** 
# NOTE: Lambda
*/

// AWS アカウント Region 参照 
data "aws_region" "self" {}

data "archive_file" "cloudwatch_alarm" {
  type        = "zip"
  source_file = "${path.module}/lambda/source/cloudwatch_alarm_notify.py"
  output_path = "${path.module}/lambda/bin/cloudwatch_alarm_notify.zip"
}

resource "aws_lambda_function" "cloudwatch_alarm" {
  filename                       = data.archive_file.cloudwatch_alarm.output_path
  function_name                  = "${var.common.project}-${var.common.environment}-cloudwatch-alarm-notify-function"
  description                    = "${var.common.project}-${var.common.environment}-cloudwatch-alarm-notify-function"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "cloudwatch_alarm_notify.lambda_handler"
  source_code_hash               = data.archive_file.cloudwatch_alarm.output_base64sha256
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = "python3.9"
  environment {
    variables = {
      channelName         = var.channel_name
      kmsEncryptedHookUrl = var.kms_encrypted_hookurl
    }
  }

  lifecycle {
    ignore_changes = [
      environment
    ]
  }

}

resource "aws_lambda_permission" "cloudwatch_alarm" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_alarm.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.cloudwatch_alarm.arn
}

/** 
# NOTE: IAM Role For CloudWatch Alarm Lambda
*/

// Lambda role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.common.project}-${var.common.environment}-${data.aws_region.self.name}-cloudwatch-alarm-notify-lambda-role"
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
}

// Lambda 基本実行 ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

/**
# NOTE: 利用しない
// CloudWatch ReadOnly ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "lambda_to_cw" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}
*/

// SSM パラメータ 読み込み ポリシー
resource "aws_iam_policy" "lambda_to_ssm" {
  name = "${var.common.project}-${var.common.environment}-${data.aws_region.self.name}-cloudwatch-alarm-notify-lambda-policy"
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

// SSM パラメータ 読み込み ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "lambda_to_ssm" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_to_ssm.arn
}

// 環境変数暗号化 KMS
resource "aws_kms_key" "cloudwatch_alarm_lambda" {
  description             = "${var.common.project}-${var.common.environment}-cloudwatch-alarm-notify-lambda-kms"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

// 環境変数暗号化 KMS Alias
resource "aws_kms_alias" "cloudwatch_alarm_lambda" {
  name          = "alias/${var.common.project}/${var.common.environment}/cloudwatch_alarm_notify_lambda_kms_key"
  target_key_id = aws_kms_key.cloudwatch_alarm_lambda.id
}