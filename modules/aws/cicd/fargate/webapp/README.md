# cicd/fargate/webapp

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.cloudwatch_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.cloudwatch_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.codebuild_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codecommit_repository.repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository) | resource |
| [aws_codedeploy_app.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.deployment_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_codepipeline.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_iam_policy.codebuild_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.codedeploy_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.codepipeline_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.codepipeline_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eventbridge_to_codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.codedeploy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eventbridge_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.codebuild_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_to_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codedeploy_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codepipeline_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codepipeline_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eventbridge_to_codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.codebuild_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codebuild_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codedeploy_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codepipeline_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codepipeline_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eventbridge_to_codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.event_pattern_build](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_spec_template_path"></a> [app\_spec\_template\_path](#input\_app\_spec\_template\_path) | n/a | `string` | `""` | no |
| <a name="input_artifact_bucket"></a> [artifact\_bucket](#input\_artifact\_bucket) | n/a | `string` | `""` | no |
| <a name="input_blue_target_group"></a> [blue\_target\_group](#input\_blue\_target\_group) | n/a | `string` | n/a | yes |
| <a name="input_codebuild_subnet_ids"></a> [codebuild\_subnet\_ids](#input\_codebuild\_subnet\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project      = string<br>    environment  = string<br>    service_name = string<br>    region       = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": "",<br>  "region": "",<br>  "service_name": ""<br>}</pre> | no |
| <a name="input_ecs_service"></a> [ecs\_service](#input\_ecs\_service) | n/a | <pre>object({<br>    cluster_name = string<br>    service_name = string<br>  })</pre> | <pre>{<br>  "cluster_name": "",<br>  "service_name": ""<br>}</pre> | no |
| <a name="input_enable_auto_deploy"></a> [enable\_auto\_deploy](#input\_enable\_auto\_deploy) | n/a | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | <pre>object({<br>    privileged_mode = bool<br>    variables = list(object({<br>      name  = string<br>      value = string<br>      type  = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_green_target_group"></a> [green\_target\_group](#input\_green\_target\_group) | n/a | `string` | n/a | yes |
| <a name="input_prod_traffic_route_listener_arns"></a> [prod\_traffic\_route\_listener\_arns](#input\_prod\_traffic\_route\_listener\_arns) | n/a | `list(string)` | n/a | yes |
| <a name="input_reference_name"></a> [reference\_name](#input\_reference\_name) | n/a | `string` | `""` | no |
| <a name="input_task_definition_template_path"></a> [task\_definition\_template\_path](#input\_task\_definition\_template\_path) | n/a | `string` | `""` | no |
| <a name="input_termination_wait_time_in_minutes"></a> [termination\_wait\_time\_in\_minutes](#input\_termination\_wait\_time\_in\_minutes) | n/a | `number` | `5` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `""` | no |

## Outputs

No outputs.

## Example

```
module "cicd_fargate_webapp" {
  source = "../example/tf-m-templates/modules/aws/cicd/fargate/webapp"

  common = {
    project      = "example"
    environment  = "dev"
    service_name = "webapp"
    region       = "ap-northeast-1"
  }

  environment = {
    privileged_mode = true
    variables = []
  }

  vpc_id               = module.network.vpc_id
  codebuild_subnet_ids = module.network.private_subnet_ids[0]


  ecs_service = {
    cluster_name = module.service_global.ecs_cluster.name
    service_name = module.service_webapp.ecs_service.name
  }

  prod_traffic_route_listener_arns = [module.service_webapp.lb_listener_https.arn]

  blue_target_group  = module.service_webapp.lb_target_group_blue.name
  green_target_group = module.service_webapp.lb_target_group_green.name

  termination_wait_time_in_minutes = 5

  artifact_bucket = module.cicd_fargate_global.artifact_bucket_id
  reference_name  = "develop"

  task_definition_template_path = "task_definitions/dev/taskdefinition.json"
  app_spec_template_path        = "deploy_scripts/appspec.yml"

  enable_auto_deploy = true
}
```