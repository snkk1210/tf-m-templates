# database/aurora/postgresql

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
| [aws_db_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_role.aurora_expansion_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aurora_expansion_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.aurora_performance_insights](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.aurora_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.aurora_performance_insights](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.aurora_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_rds_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aurora_cluster"></a> [aurora\_cluster](#input\_aurora\_cluster) | n/a | <pre>object({<br>    master_username              = string<br>    master_password              = string<br>    backup_retention_period      = number<br>    engine                       = string<br>    engine_version               = string<br>    preferred_backup_window      = string<br>    preferred_maintenance_window = string<br>    apply_immediately            = bool<br>    storage_encrypted            = bool<br>    deletion_protection          = bool<br>    skip_final_snapshot          = bool<br>  })</pre> | <pre>{<br>  "apply_immediately": false,<br>  "backup_retention_period": 14,<br>  "deletion_protection": false,<br>  "engine": "",<br>  "engine_version": "",<br>  "master_password": "",<br>  "master_username": "",<br>  "preferred_backup_window": "",<br>  "preferred_maintenance_window": "",<br>  "skip_final_snapshot": true,<br>  "storage_encrypted": true<br>}</pre> | no |
| <a name="input_aurora_cluster_instance"></a> [aurora\_cluster\_instance](#input\_aurora\_cluster\_instance) | n/a | <pre>object({<br>    count                      = number<br>    instance_class             = string<br>    engine                     = string<br>    engine_version             = string<br>    storage_type               = string<br>    publicly_accessible        = bool<br>    auto_minor_version_upgrade = bool<br>    apply_immediately          = bool<br>  })</pre> | <pre>{<br>  "apply_immediately": false,<br>  "auto_minor_version_upgrade": false,<br>  "count": 0,<br>  "engine": "",<br>  "engine_version": "",<br>  "instance_class": "",<br>  "publicly_accessible": false,<br>  "storage_type": ""<br>}</pre> | no |
| <a name="input_aurora_cluster_parameter_group"></a> [aurora\_cluster\_parameter\_group](#input\_aurora\_cluster\_parameter\_group) | n/a | <pre>object({<br>    family    = string<br>    parameter = map(string)<br>  })</pre> | <pre>{<br>  "family": "",<br>  "parameter": {}<br>}</pre> | no |
| <a name="input_aurora_db_parameter_group"></a> [aurora\_db\_parameter\_group](#input\_aurora\_db\_parameter\_group) | n/a | <pre>object({<br>    family    = string<br>    parameter = map(string)<br>  })</pre> | <pre>{<br>  "family": "",<br>  "parameter": {}<br>}</pre> | no |
| <a name="input_aurora_ingress"></a> [aurora\_ingress](#input\_aurora\_ingress) | n/a | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | n/a | `number` | `90` | no |
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project      = string<br>    environment  = string<br>    service_name = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": "",<br>  "service_name": ""<br>}</pre> | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.

## Example

```
module "database_aurora_postgresql" {
  source = "../../tf-m-templates/modules/aws/database/aurora/postgresql"

  common = {
    project      = "example"
    environment  = "dev"
    service_name = "postgresql"
  }

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.isolated_subnet_ids

  aurora_cluster_parameter_group = {
    family    = "aurora-postgresql14"
    parameter = {}
  }

  aurora_db_parameter_group = {
    family    = "aurora-postgresql14"
    parameter = {}
  }

  aurora_cluster = {
    master_username              = "root"
    master_password              = "vagrantvagrant"
    backup_retention_period      = 30
    engine                       = "aurora-postgresql"
    engine_version               = "14.9"
    preferred_backup_window      = "17:00-18:00"
    preferred_maintenance_window = "mon:18:00-mon:19:00"
    apply_immediately            = true
    deletion_protection          = false
    skip_final_snapshot          = false
    storage_encrypted            = true
  }

  aurora_cluster_instance = {
    count                      = 1
    instance_class             = "db.t3.medium"
    engine                     = "aurora-postgresql"
    engine_version             = "14.9"
    apply_immediately          = true
    auto_minor_version_upgrade = false
    publicly_accessible        = false
    storage_type               = "gp2"
  }
}
```