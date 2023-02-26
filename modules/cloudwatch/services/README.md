# cloudwatch/services

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
| [aws_cloudwatch_metric_alarm.alb_httpcode_elb_5xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.alb_httpcode_target_5xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.fargate_cpuutilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.fargate_memoryutilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.fargate_runningtaskcount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_alarm_notify_sns_topic_arn"></a> [cloudwatch\_alarm\_notify\_sns\_topic\_arn](#input\_cloudwatch\_alarm\_notify\_sns\_topic\_arn) | n/a | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project     = string<br>    environment = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": ""<br>}</pre> | no |
| <a name="input_fargate_service_alarm"></a> [fargate\_service\_alarm](#input\_fargate\_service\_alarm) | n/a | <pre>list(object({<br><br>    /** <br>    # NOTE: Fargate<br>    */<br>    fargate_name = string<br><br>    // Fargate CPUUtilization<br>    fargate_cpuutilization_evaluation_periods = string<br>    fargate_cpuutilization_period             = string<br>    fargate_cpuutilization_statistic          = string<br>    fargate_cpuutilization_threshold          = string<br><br>    // Fargate MemoryUtilization<br>    fargate_memoryutilization_evaluation_periods = string<br>    fargate_memoryutilization_period             = string<br>    fargate_memoryutilization_statistic          = string<br>    fargate_memoryutilization_threshold          = string<br>    // Fargate RunningTaskCount<br>    fargate_runningtaskcount_evaluation_periods = string<br>    fargate_runningtaskcount_period             = string<br>    fargate_runningtaskcount_statistic          = string<br>    fargate_runningtaskcount_threshold          = string<br>    fargate_runningtaskcount_actions_enabled    = bool<br><br>    /** <br>    # NOTE: ALB<br>    */<br>    alb_name = string<br>    alb_arn  = string<br><br>    // ALB HTTPCode_ELB_5XX_Count<br>    alb_httpcode_elb_5xx_count_evaluation_periods = string<br>    alb_httpcode_elb_5xx_count_period             = string<br>    alb_httpcode_elb_5xx_count_statistic          = string<br>    alb_httpcode_elb_5xx_count_threshold          = string<br>    // ALB HTTPCode_Target_5XX_Count<br>    alb_httpcode_target_5xx_count_evaluation_periods = string<br>    alb_httpcode_target_5xx_count_period             = string<br>    alb_httpcode_target_5xx_count_statistic          = string<br>    alb_httpcode_target_5xx_count_threshold          = string<br><br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
