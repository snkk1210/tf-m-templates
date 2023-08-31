/**
# IAM
*/
data "aws_caller_identity" "self" {}

resource "aws_iam_policy" "gitlab_to_codecommit" {
  name   = "${var.common.project}-${var.common.environment}-gitlab-to-codecommit-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.gitlab_to_codecommit.json

  tags = {
    "Name"    = "${var.common.project}-${var.common.environment}-gitlab-to-codecommit-policy"
    Createdby = "Terraform"
  }
}

data "aws_iam_policy_document" "gitlab_to_codecommit" {
  statement {
    actions = [
      "codecommit:GitPull",
      "codecommit:GitPush"
    ]

    resources = [
      "arn:aws:codecommit:*:${data.aws_caller_identity.self.account_id}:*"
    ]
  }
}

resource "aws_iam_user" "gitlab_to_codecommit" {
  name = "${var.common.project}-${var.common.environment}-gitlab-to-codecommit-user"

  tags = {
    "Name"    = "${var.common.project}-${var.common.environment}-gitlab-to-codecommit-user"
    Createdby = "Terraform"
  }
}

resource "aws_iam_user_policy_attachment" "gitlab_to_codecommit" {
  user       = aws_iam_user.gitlab_to_codecommit.name
  policy_arn = aws_iam_policy.gitlab_to_codecommit.arn
}

resource "aws_iam_service_specific_credential" "gitlab_to_codecommit" {
  service_name = "codecommit.amazonaws.com"
  user_name    = aws_iam_user.gitlab_to_codecommit.name
}