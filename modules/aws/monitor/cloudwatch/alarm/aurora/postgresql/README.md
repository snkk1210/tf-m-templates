# cloudwatch/aurora/postgresql

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
| [aws_cloudwatch_metric_alarm.aurora_databaseconnections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.aurora_freelocalstorage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.aurora_reader_cpuutilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.aurora_reader_freeablememory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.aurora_writer_cpuutilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.aurora_writer_freeablememory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aurora_cluster_alarm"></a> [aurora\_cluster\_alarm](#input\_aurora\_cluster\_alarm) | n/a | <pre>list(object({<br>    aurora_cluster_name = string<br><br>    // Cluster Writer CPUUtilization<br>    aurora_writer_cpuutilization_evaluation_periods = string<br>    aurora_writer_cpuutilization_period             = string<br>    aurora_writer_cpuutilization_statistic          = string<br>    aurora_writer_cpuutilization_threshold          = string<br><br>    // Cluster Reader CPUUtilization<br>    aurora_reader_cpuutilization_evaluation_periods = string<br>    aurora_reader_cpuutilization_period             = string<br>    aurora_reader_cpuutilization_statistic          = string<br>    aurora_reader_cpuutilization_threshold          = string<br><br>    // Cluster Writer FreeableMemory<br>    aurora_writer_freeablememory_evaluation_periods = string<br>    aurora_writer_freeablememory_period             = string<br>    aurora_writer_freeablememory_statistic          = string<br>    aurora_writer_freeablememory_threshold          = string<br><br>    // Cluster Reader FreeableMemory<br>    aurora_reader_freeablememory_evaluation_periods = string<br>    aurora_reader_freeablememory_period             = string<br>    aurora_reader_freeablememory_statistic          = string<br>    aurora_reader_freeablememory_threshold          = string<br><br>  }))</pre> | n/a | yes |
| <a name="input_aurora_instance_alarm"></a> [aurora\_instance\_alarm](#input\_aurora\_instance\_alarm) | n/a | <pre>list(object({<br>    aurora_instance_name = string<br><br>    // Instance DatabaseConnections<br>    aurora_databaseconnections_evaluation_periods = string<br>    aurora_databaseconnections_period             = string<br>    aurora_databaseconnections_statistic          = string<br>    aurora_databaseconnections_threshold          = string<br><br>    // Cluster FreeLocalStorage<br>    aurora_freelocalstorage_evaluation_periods = string<br>    aurora_freelocalstorage_period             = string<br>    aurora_freelocalstorage_statistic          = string<br>    aurora_freelocalstorage_threshold          = string<br><br>  }))</pre> | n/a | yes |
| <a name="input_cloudwatch_alarm_notify_sns_topic_arn"></a> [cloudwatch\_alarm\_notify\_sns\_topic\_arn](#input\_cloudwatch\_alarm\_notify\_sns\_topic\_arn) | n/a | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project     = string<br>    environment = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": ""<br>}</pre> | no |

## Outputs

No outputs.
