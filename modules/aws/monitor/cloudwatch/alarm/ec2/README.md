# cloudwatch/ec2

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
| [aws_cloudwatch_metric_alarm.ec2_cpuutilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_statuscheckfailed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_alarm_notify_sns_topic_arn"></a> [cloudwatch\_alarm\_notify\_sns\_topic\_arn](#input\_cloudwatch\_alarm\_notify\_sns\_topic\_arn) | n/a | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project     = string<br>    environment = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": ""<br>}</pre> | no |
| <a name="input_ec2_instance_alarm"></a> [ec2\_instance\_alarm](#input\_ec2\_instance\_alarm) | n/a | <pre>list(object({<br>    ec2_instance_name = string<br>    ec2_instance_id   = string<br><br>    // EC2 CPUUtilization <br>    ec2_cpuutilization_evaluation_periods = string<br>    ec2_cpuutilization_period             = string<br>    ec2_cpuutilization_statistic          = string<br>    ec2_cpuutilization_threshold          = string<br><br>    // EC2 StatusCheckFailed<br>    ec2_statuscheckfailed_evaluation_periods = string<br>    ec2_statuscheckfailed_period             = string<br>    ec2_statuscheckfailed_statistic          = string<br>    ec2_statuscheckfailed_threshold          = string<br><br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
