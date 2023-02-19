/** 
# NOTE: Lambda
*/

// AWS アカウント Region 参照 
data "aws_region" "self" {}

data "archive_file" "ses_email_receiving" {
  type        = "zip"
  source_file = "${path.module}/lambda/source/ses_email_receiving_notify.py"
  output_path = "${path.module}/lambda/bin/ses_email_receiving_notify.zip"
}

resource "aws_lambda_function" "ses_email_receiving" {
  filename                       = data.archive_file.ses_email_receiving.output_path
  function_name                  = "${var.common.project}-${var.common.environment}-ses-email-receiving-notify-function"
  description                    = "${var.common.project}-${var.common.environment}-ses-email-receiving-notify-function"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "ses_email_receiving_notify.lambda_handler"
  source_code_hash               = data.archive_file.ses_email_receiving.output_base64sha256
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
      //environment
    ]
  }

}

resource "aws_lambda_permission" "ses_email_receiving" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ses_email_receiving.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.ses_email_receiving.arn
}

/** 
# NOTE: IAM Role For SES Email Receiving Lambda
*/

// Lambda role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.common.project}-${var.common.environment}-${data.aws_region.self.name}-ses-email-receiving-notify-lambda-role"
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
  name = "${var.common.project}-${var.common.environment}-${data.aws_region.self.name}-ses-email-receiving-notify-lambda-policy"
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
resource "aws_kms_key" "ses_email_receiving_lambda" {
  description             = "${var.common.project}-${var.common.environment}-ses-email-receiving-notify-lambda-kms"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

// 環境変数暗号化 KMS Alias
resource "aws_kms_alias" "ses_email_receiving_lambda" {
  name          = "alias/${var.common.project}/${var.common.environment}/ses_email_receiving_notify_lambda_kms_key"
  target_key_id = aws_kms_key.ses_email_receiving_lambda.id
}