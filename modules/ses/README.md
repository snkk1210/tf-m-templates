# ses

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic.ses_feedback](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project     = string<br>    environment = string<br>    region      = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": "",<br>  "region": ""<br>}</pre> | no |

## Outputs

No outputs.
