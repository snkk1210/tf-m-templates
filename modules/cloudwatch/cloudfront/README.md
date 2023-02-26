# cloudwatch/cloudfront

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.cloudfront_5xxerrorrate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudfront_alarm"></a> [cloudfront\_alarm](#input\_cloudfront\_alarm) | n/a | <pre>list(object({<br><br>    /** <br>    # NOTE: CloudFront<br>    */<br>    cloudfront_name = string<br>    cloudfront_id   = string<br><br>    // CloudFront 5xxErrorRate<br>    cloudfront_5xxerrorrate_evaluation_periods = string<br>    cloudfront_5xxerrorrate_period             = string<br>    cloudfront_5xxerrorrate_statistic          = string<br>    cloudfront_5xxerrorrate_threshold          = string<br><br>  }))</pre> | n/a | yes |
| <a name="input_cloudwatch_alarm_notify_sns_topic_arn"></a> [cloudwatch\_alarm\_notify\_sns\_topic\_arn](#input\_cloudwatch\_alarm\_notify\_sns\_topic\_arn) | n/a | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project     = string<br>    environment = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": ""<br>}</pre> | no |

## Outputs

No outputs.
