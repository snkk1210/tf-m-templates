## cicd/terraform/ci/github

### What is this ?

Build a CI mechanism for HCL ( Terraform ) using GitHub as the source.

### How to use ?

```
module "cicd_terraform_ci_github" {
  source = "git::https://github.com/snkk1210/tf-m-templates.git//modules/aws/cicd/terraform/ci/github"

  common = {
    "project"      = "sample"
    "environment"  = "sandbox"
    "service_name" = "hcl"
    "type"         = "ci"
  }

  source_info = {
    location        = "https://github.com/<ORGANIZATION_NAME>/<REPOSITORY_NAME>.git"
    git_clone_depth = 1
    buildspec       = "./deploy_scripts/ci/buildspec.yml"
  }

  environment_variable = {
    variables = [
      {
        name  = "APP_ID_SSM_ARN"
        value = "arn:aws:ssm:ap-northeast-1:xxxxxxxxxxxx:parameter/path/to/id"
        type  = "PLAINTEXT"
      },
      {
        name  = "APP_SECRET_SSM_ARN"
        value = "arn:aws:ssm:ap-northeast-1:xxxxxxxxxxxx:parameter/path/to/secret"
        type  = "PLAINTEXT"
      },
      {
        name  = "REPO_NAME"
        value = "<ORGANIZATION_NAME>/<REPOSITORY_NAME>"
        type  = "PLAINTEXT"
      }
    ]
  }

  filter_groups = [
    {
      event_pattern = "PULL_REQUEST_CREATED"
      file_pattern  = "^env/dev/*"
    },
    {
      event_pattern = "PULL_REQUEST_UPDATED"
      file_pattern  = "^env/dev/*"
    },
    {
      event_pattern = "PULL_REQUEST_REOPENED"
      file_pattern  = "^env/dev/*"
    }
  ]
}
```