/** 
# NOTE: IAM For Bastion
*/

// Bastion role
resource "aws_iam_role" "bastion_role" {
  name = "${var.common.project}-${var.common.environment}-bastion-ec2-iam-role01"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

// Bastion SSM 操作 ロール アタッチ
resource "aws_iam_role_policy_attachment" "ec2_to_ssm" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

// Bastion CloudWatch 操作 ロール アタッチ
resource "aws_iam_role_policy_attachment" "ec2_to_cwlog" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

// Bastion SES 操作 ロール アタッチ
resource "aws_iam_role_policy_attachment" "ec2_to_ses" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

// ECS 操作 ポリシー アタッチ
data "aws_iam_policy_document" "ec2_to_ecs" {
  statement {
    actions = [
      "iam:PassRole",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeServices",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:UpdateContainerAgent",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:RunTask",
      "ecs:RegisterTaskDefinition",
      "ecs:ListTaskDefinitions",
      "ecs:ExecuteCommand",
      "ecs:DescribeTaskDefinition"
    ]

    resources = ["*"]

  }
}

// ECS 操作 ポリシー
resource "aws_iam_policy" "ec2_to_ecs" {
  name   = "${var.common.project}-${var.common.environment}-ec2-to-ecs-iam-policy01"
  path   = "/"
  policy = data.aws_iam_policy_document.ec2_to_ecs.json
}

// ECS 操作 ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "ec2_to_ecs" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.ec2_to_ecs.arn
}

// ECR 読み込み ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "ec2_to_ecr" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

// S3 読み込み ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "ec2_to_s3" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

// IAM 読み込み ポリシー アタッチ
resource "aws_iam_role_policy_attachment" "ec2_to_iam" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

// Bastion Profile
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.common.project}-${var.common.environment}-bastion-ec2-profile01"
  role = aws_iam_role.bastion_role.name
}