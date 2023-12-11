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

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cloud9_role.name
}

resource "aws_iam_instance_profile" "cloud9_profile" {
  name = "${var.common.project}-${var.common.environment}-eks-cloud9-role"
  role = aws_iam_role.cloud9_role.name
}