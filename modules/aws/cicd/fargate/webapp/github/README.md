## cicd/fargate/webapp/github

### What is this ?

Create a B/G deployment mechanism for a generic webapp ( API ) component hosted on GitHub.

### How to use ?

```
module "webapp_cicd" {
  source = "git::https://github.com/snkk1210/tf-m-templates.git//modules/aws/cicd/fargate/webapp/github"

  common = {
    project      = "snkk1210"
    environment  = "sandbox"
    service_name = "api"
    type         = "cicd"
  }

  environment_variable = {
    variables = [
      {
        name  = "PROJECT"
        value = "snkk1210"
        type  = "PLAINTEXT"
      },
      {
        name  = "ENVIRONMENT"
        value = "sandbox"
        type  = "PLAINTEXT"
      },
      {
        name  = "SERVICE_NAME"
        value = "api"
        type  = "PLAINTEXT"
      },
      {
        name  = "AWS_REGION"
        value = "ap-northeast-1"
        type  = "PLAINTEXT"
      },
      {
        name  = "AWS_ACCOUNT_ID"
        value = "<AWS_ACCOUNT_ID>"
        type  = "PLAINTEXT"
      },
      {
        name  = "IMAGE_URI_WEB"
        value = <ECR_WEB_REPOSITORY_URL>
        type  = "PLAINTEXT"
      },
      {
        name  = "IMAGE_URI_APP"
        value = <ECR_APP_REPOSITORY_URL>
        type  = "PLAINTEXT"
      }
    ]
  }

  vpc_id               = <VPC_ID>
  codebuild_subnet_ids = [
    "subnet-xxxxx",
    "subnet-xxxxx"
  ]

  ecs_service = {
    cluster_name = "<ECS_CLUSTER_NAME>"
    service_name = "<ECS_SERVICE_NAME>"
  }

  lb_info = {
    prod_traffic_route_listener_arns = [
      "<LISTENER_ARNS>"
    ]
    blue_target_group  = <BLUE_TARGET_GROUP_NAME>
    green_target_group = <GREEN_TARGET_GROUP_NAME>
  }

  codestarconnections_connection_arn = "<CODESTARCONNECTIONS_CONNECTION_ARN>"
  repository_name                    = "<ORGANIZATION_NAME>/<REPOSITORY_NAME>"
  branch_name                        = "main"
  task_definition_template_path      = "task_definitions/sandbox/taskdefinition.json"
  app_spec_template_path             = "deploy_scripts/appspec.yml"

  s3_bucket_force_destroy = true
}
```