/** 
# IAM Role for CodeBuild
*/
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-role${var.sfx}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-${var.common.type}-codebuild-role${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "administrator_access" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}