/** 
# IAM Role ( GitHub Actions )
*/
resource "aws_iam_role" "gha_deploy" {
  name               = "${var.common.project}-${var.common.environment}-${var.common.service_name}-gha-deploy-role${var.sfx}"
  assume_role_policy = data.aws_iam_policy_document.gha_deploy.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-gha-deploy-role${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

data "aws_iam_policy_document" "gha_deploy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.self.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.repository_name}:*"]
    }
  }
}

/** 
# IAM Policy ( GitHub Actions )
*/
resource "aws_iam_policy" "deploy" {
  name   = "${var.common.project}-${var.common.environment}-${var.common.service_name}-deploy-policy${var.sfx}"
  path   = "/"
  policy = data.aws_iam_policy_document.deploy.json

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-${var.common.service_name}-deploy-policy${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "deploy" {
  role       = aws_iam_role.gha_deploy.name
  policy_arn = aws_iam_policy.deploy.arn
}

data "aws_iam_policy_document" "deploy" {
  statement {
    actions = [
      "ecs:RegisterTaskDefinition"
    ]
    resources = [
      "${aws_ecs_task_definition.this.arn_without_revision}:*"
    ]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
    resources = [
      aws_ecr_repository.app.arn,
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = [
      aws_iam_role.ecs_role.arn,
    ]
  }

  statement {
    actions = [
      "ecs:DescribeServices",
      "codedeploy:GetDeploymentGroup",
      "codedeploy:CreateDeployment",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]
    resources = [
      aws_ecs_service.this.id,
      aws_codedeploy_app.this.arn,
      "arn:aws:codedeploy:${var.common.region}:${data.aws_caller_identity.self.account_id}:deploymentconfig:*",
      aws_codedeploy_deployment_group.this.arn,
    ]
  }
}