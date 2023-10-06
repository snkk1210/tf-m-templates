# service/batch

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
| [aws_batch_compute_environment.batch_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_compute_environment) | resource |
| [aws_batch_job_definition.batch_job_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_job_definition) | resource |
| [aws_batch_job_queue.batch_job_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_job_queue) | resource |
| [aws_cloudwatch_event_rule.batch_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.batch_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_lifecycle_policy.batch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.batch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_policy.batch_to_cw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.batch_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eventbridge_to_batch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.batch_environment_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_batch_job_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eventbridge_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.batch_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.batch_to_cw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.batch_to_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.batch_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eventbridge_to_batch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ecs_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.batch_to_cw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eventbridge_to_batch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.batch_definition](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_batch_cron"></a> [batch\_cron](#input\_batch\_cron) | n/a | `string` | `"cron(00 20 * * ? *)"` | no |
| <a name="input_batch_definition"></a> [batch\_definition](#input\_batch\_definition) | n/a | <pre>object({<br>    vcpu    = number<br>    memory  = number<br>    command = string<br>  })</pre> | <pre>{<br>  "command": "ls",<br>  "memory": 512,<br>  "vcpu": 0.25<br>}</pre> | no |
| <a name="input_batch_subnet_ids"></a> [batch\_subnet\_ids](#input\_batch\_subnet\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project      = string<br>    environment  = string<br>    service_name = string<br>    region       = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": "",<br>  "region": "",<br>  "service_name": ""<br>}</pre> | no |
| <a name="input_ecr_repository_batch"></a> [ecr\_repository\_batch](#input\_ecr\_repository\_batch) | n/a | <pre>object({<br>    image_tag_mutability          = string<br>    scan_on_push                  = bool<br>    lifecycle_policy_count_number = number<br>  })</pre> | <pre>{<br>  "image_tag_mutability": "MUTABLE",<br>  "lifecycle_policy_count_number": 15,<br>  "scan_on_push": false<br>}</pre> | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | n/a | `number` | `30` | no |
| <a name="input_max_vcpus"></a> [max\_vcpus](#input\_max\_vcpus) | n/a | `number` | `2` | no |
| <a name="input_timeout_sec"></a> [timeout\_sec](#input\_timeout\_sec) | n/a | `number` | `3600` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `""` | no |

## Outputs

No outputs.

## Example

```
module "service_batch" {
  source = "../example/tf-m-templates/modules/aws/service/batch"

  common = {
    project      = "example"
    environment  = "dev"
    service_name = "batch"
    region       = "ap-northeast-1"
  }

  vpc_id           = module.network.vpc_id
  batch_subnet_ids = module.network.private_subnet_ids[0]

  batch_definition = {
    vcpu    = 0.25
    memory  = 512
    command = "ls"
  }

  batch_cron = "cron(00 19 * * ? *)"

  ecr_repository_batch = {
    image_tag_mutability          = "MUTABLE"
    scan_on_push                  = false
    lifecycle_policy_count_number = 15
  }

  log_retention_in_days = 30
  max_vcpus             = 2
  timeout_sec           = 300
}
```