# cloudwatch/memorydb

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
| [aws_cloudwatch_metric_alarm.memorydb_cpuutilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.memorydb_evictions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.memorydb_freeablememory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.memorydb_swapusage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_alarm_notify_sns_topic_arn"></a> [cloudwatch\_alarm\_notify\_sns\_topic\_arn](#input\_cloudwatch\_alarm\_notify\_sns\_topic\_arn) | n/a | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project     = string<br>    environment = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": ""<br>}</pre> | no |
| <a name="input_memorydb_cluster_alarm"></a> [memorydb\_cluster\_alarm](#input\_memorydb\_cluster\_alarm) | n/a | <pre>list(object({<br>    memorydb_cluster_name = string<br><br>    // MemoryDB for Redis CPUUtilization <br>    memorydb_cpuutilization_evaluation_periods = string<br>    memorydb_cpuutilization_period             = string<br>    memorydb_cpuutilization_statistic          = string<br>    memorydb_cpuutilization_threshold          = string<br><br>    // MemoryDB for Redis FreeableMemory<br>    memorydb_freeablememory_evaluation_periods = string<br>    memorydb_freeablememory_period             = string<br>    memorydb_freeablememory_statistic          = string<br>    memorydb_freeablememory_threshold          = string<br><br>    // MMemoryDB for Redis SwapUsage<br>    memorydb_swapusage_evaluation_periods = string<br>    memorydb_swapusage_period             = string<br>    memorydb_swapusage_statistic          = string<br>    memorydb_swapusage_threshold          = string<br><br>    // MemoryDB for Redis Evictions<br>    memorydb_evictions_evaluation_periods = string<br>    memorydb_evictions_period             = string<br>    memorydb_evictions_statistic          = string<br>    memorydb_evictions_threshold          = string<br><br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
