## service/fargate/webapp

### What is this ?

Create an API component for ECS Fargate consisting of 2 containers.

### How to use ?

#### API

```
module "webapp" {
  source = "git::https://github.com/snkk1210/tf-m-templates.git//modules/aws/service/fargate/webapp"

  common = {
    project      = "snkk1210"
    environment  = "sandbox"
    service_name = "api"
    region       = "ap-northeast-1"
  }

  vpc_id = module.network_3az.vpc_id

  lb = {
    internal            = false
    load_balancer_type  = "application"
    security_groups     = []
    subnet_ids          = module.network_3az.public_subnet_ids
    access_logs_enabled = true
  }

  lb_listener_https = {
    port            = 443
    protocol        = "HTTPS"
    certificate_arn = "<CERTIFICATE_ARN>"
    ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
    default_action = {
      type = "forward"
    }
  }

  ecs_service = {
    cluster                    = "<CLUSTER_ARN>"
    launch_type                = "FARGATE"
    platform_version           = "1.4.0"
    desired_count              = 1
    deployment_controller_type = "CODE_DEPLOY"
    assign_public_ip           = true
    enable_execute_command     = true
    subnet_ids                 = [for subnet in module.network_3az.private_subnet_ids : subnet[0]]
  }

  ecr_repository_web = {
    image_tag_mutability          = "MUTABLE"
    force_delete                  = true
    scan_on_push                  = false
    lifecycle_policy_count_number = 15
  }

  ecr_repository_app = {
    image_tag_mutability          = "MUTABLE"
    force_delete                  = true
    scan_on_push                  = false
    lifecycle_policy_count_number = 15
  }

  ecs_ingress_cidr_blocks = ["0.0.0.0/0"]

  force_destroy = true
}
```

#### CI/CD

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
        value = module.webapp.ecr_repository_web.repository_url
        type  = "PLAINTEXT"
      },
      {
        name  = "IMAGE_URI_APP"
        value = module.webapp.ecr_repository_app.repository_url
        type  = "PLAINTEXT"
      }
    ]
  }

  vpc_id               = module.network_3az.vpc_id
  codebuild_subnet_ids = [for subnet in module.network_3az.private_subnet_ids : subnet[0]]

  ecs_service = {
    cluster_name = "<CLUSTER_NAME>"
    service_name = module.webapp.ecs_service_this.name
  }

  lb_info = {
    prod_traffic_route_listener_arns = [
      module.webapp.lb_listener_https.arn
    ]
    blue_target_group  = module.webapp.lb_target_group_blue.name
    green_target_group = module.webapp.lb_target_group_green.name
  }

  codestarconnections_connection_arn = "<CODESTARCONNECTIONS_CONNECTION_ARN>"
  repository_name                    = "<ORGANIZATION_NAME>/<REPOSITORY_NAME>"
  branch_name                        = "main"
  task_definition_template_path      = "task_definitions/sandbox/taskdefinition.json"
  app_spec_template_path             = "deploy_scripts/appspec.yml"

  s3_bucket_force_destroy = true
}
```