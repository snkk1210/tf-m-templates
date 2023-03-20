# cloudwatch/alb

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_alarm"></a> [alb\_alarm](#input\_alb\_alarm) | n/a | <pre>list(object({<br><br>    /** <br>    # NOTE: ALB<br>    */<br>    alb_name = string<br>    alb_arn  = string<br><br>    // ALB HTTPCode_ELB_5XX_Count<br>    alb_httpcode_elb_5xx_count_evaluation_periods = string<br>    alb_httpcode_elb_5xx_count_period             = string<br>    alb_httpcode_elb_5xx_count_statistic          = string<br>    alb_httpcode_elb_5xx_count_threshold          = string<br>    // ALB HTTPCode_Target_5XX_Count<br>    alb_httpcode_target_5xx_count_evaluation_periods = string<br>    alb_httpcode_target_5xx_count_period             = string<br>    alb_httpcode_target_5xx_count_statistic          = string<br>    alb_httpcode_target_5xx_count_threshold          = string<br><br>  }))</pre> | n/a | yes |
| <a name="input_cloudwatch_alarm_notify_sns_topic_arn"></a> [cloudwatch\_alarm\_notify\_sns\_topic\_arn](#input\_cloudwatch\_alarm\_notify\_sns\_topic\_arn) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
