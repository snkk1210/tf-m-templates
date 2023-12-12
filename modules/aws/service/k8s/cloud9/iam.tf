/** 
# Cloud9
*/
data "aws_iam_policy_document" "cloud9_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com","cloud9.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloud9_role" {
  name               = "${var.common.project}-${var.common.environment}-eks-cloud9-role"
  assume_role_policy = data.aws_iam_policy_document.cloud9_assume_role.json
}

resource "aws_iam_role_policy_attachment" "aws_cloud9_ssm_instance_profile" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCloud9SSMInstanceProfile"
  role       = aws_iam_role.cloud9_role.name
}

data "aws_iam_policy_document" "cloud9_to_eks" {
  statement {
    actions = [
      "eks:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloud9_to_eks" {
  name   = "${var.common.project}-${var.common.environment}-cloud9-to-eks-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.cloud9_to_eks.json
}

resource "aws_iam_role_policy_attachment" "cloud9_to_eks" {
  role       = aws_iam_role.cloud9_role.name
  policy_arn = aws_iam_policy.cloud9_to_eks.arn
}

resource "aws_iam_instance_profile" "cloud9_profile" {
  name = "${var.common.project}-${var.common.environment}-eks-cloud9-role"
  role = aws_iam_role.cloud9_role.name
}