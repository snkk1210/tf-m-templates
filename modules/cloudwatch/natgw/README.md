# cloudwatch/natgw

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
| [aws_cloudwatch_metric_alarm.natgw_errorportallocation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_alarm_notify_sns_topic_arn"></a> [cloudwatch\_alarm\_notify\_sns\_topic\_arn](#input\_cloudwatch\_alarm\_notify\_sns\_topic\_arn) | n/a | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project     = string<br>    environment = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": ""<br>}</pre> | no |
| <a name="input_natgw_instance_alarm"></a> [natgw\_instance\_alarm](#input\_natgw\_instance\_alarm) | n/a | <pre>list(object({<br>    natgw_instance_name = string<br>    natgw_instance_id   = string<br><br>    // NATGW ErrorPortAllocation <br>    natgw_errorportallocation_evaluation_periods = string<br>    natgw_errorportallocation_period             = string<br>    natgw_errorportallocation_statistic          = string<br>    natgw_errorportallocation_threshold          = string<br><br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
