# service/fargate/webapp

## Requirements

service/fargate/global

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
| [aws_appautoscaling_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_lifecycle_policy.app_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_lifecycle_policy.web_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ecs_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecs_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecs_to_ssmmessages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_to_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_to_ssmmessages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_to_xray](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.listener_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.listener_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.blue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.green](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecs_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_to_ssmmessages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.task](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_subnet_ids"></a> [alb\_subnet\_ids](#input\_alb\_subnet\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_appautoscaling_policy"></a> [appautoscaling\_policy](#input\_appautoscaling\_policy) | n/a | <pre>object({<br>    policy_type            = string<br>    predefined_metric_type = string<br>    statistic              = string<br>    target_value           = number<br>    disable_scale_in       = bool<br>    scale_in_cooldown      = number<br>    scale_out_cooldown     = number<br>  })</pre> | <pre>{<br>  "disable_scale_in": false,<br>  "policy_type": "TargetTrackingScaling",<br>  "predefined_metric_type": "ECSServiceAverageCPUUtilization",<br>  "scale_in_cooldown": 300,<br>  "scale_out_cooldown": 300,<br>  "statistic": "Maximum",<br>  "target_value": 40<br>}</pre> | no |
| <a name="input_appautoscaling_target"></a> [appautoscaling\_target](#input\_appautoscaling\_target) | n/a | <pre>object({<br>    max_capacity       = number<br>    min_capacity       = number<br>    scalable_dimension = string<br>    service_namespace  = string<br>  })</pre> | <pre>{<br>  "max_capacity": 1,<br>  "min_capacity": 1,<br>  "scalable_dimension": "ecs:service:DesiredCount",<br>  "service_namespace": "ecs"<br>}</pre> | no |
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project      = string<br>    environment  = string<br>    service_name = string<br>    region       = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": "",<br>  "region": "",<br>  "service_name": ""<br>}</pre> | no |
| <a name="input_ecr_repository_app"></a> [ecr\_repository\_app](#input\_ecr\_repository\_app) | n/a | <pre>object({<br>    image_tag_mutability          = string<br>    scan_on_push                  = bool<br>    lifecycle_policy_count_number = number<br>  })</pre> | <pre>{<br>  "image_tag_mutability": "MUTABLE",<br>  "lifecycle_policy_count_number": 15,<br>  "scan_on_push": false<br>}</pre> | no |
| <a name="input_ecr_repository_web"></a> [ecr\_repository\_web](#input\_ecr\_repository\_web) | n/a | <pre>object({<br>    image_tag_mutability          = string<br>    scan_on_push                  = bool<br>    lifecycle_policy_count_number = number<br>  })</pre> | <pre>{<br>  "image_tag_mutability": "MUTABLE",<br>  "lifecycle_policy_count_number": 15,<br>  "scan_on_push": false<br>}</pre> | no |
| <a name="input_ecs_cluster_id"></a> [ecs\_cluster\_id](#input\_ecs\_cluster\_id) | n/a | `string` | `""` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | n/a | `string` | `""` | no |
| <a name="input_ecs_log_retention_in_days"></a> [ecs\_log\_retention\_in\_days](#input\_ecs\_log\_retention\_in\_days) | n/a | `number` | `14` | no |
| <a name="input_ecs_service"></a> [ecs\_service](#input\_ecs\_service) | n/a | <pre>object({<br>    launch_type                = string<br>    platform_version           = string<br>    desired_count              = number<br>    deployment_controller_type = string<br>  })</pre> | <pre>{<br>  "deployment_controller_type": "ECS",<br>  "desired_count": 1,<br>  "launch_type": "FARGATE",<br>  "platform_version": "1.4.0"<br>}</pre> | no |
| <a name="input_ecs_subnet_ids"></a> [ecs\_subnet\_ids](#input\_ecs\_subnet\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_ecs_task"></a> [ecs\_task](#input\_ecs\_task) | n/a | <pre>object({<br>    cpu          = number<br>    memory       = number<br>    network_mode = string<br>  })</pre> | <pre>{<br>  "cpu": 256,<br>  "memory": 512,<br>  "network_mode": "awsvpc"<br>}</pre> | no |
| <a name="input_lb_health_check"></a> [lb\_health\_check](#input\_lb\_health\_check) | n/a | <pre>object({<br>    interval            = number<br>    path                = string<br>    port                = number<br>    protocol            = string<br>    timeout             = number<br>    unhealthy_threshold = number<br>    matcher             = string<br>  })</pre> | <pre>{<br>  "interval": 30,<br>  "matcher": "200",<br>  "path": "/",<br>  "port": 80,<br>  "protocol": "HTTP",<br>  "timeout": 6,<br>  "unhealthy_threshold": 3<br>}</pre> | no |
| <a name="input_lb_listener_http"></a> [lb\_listener\_http](#input\_lb\_listener\_http) | n/a | <pre>object({<br>    port           = number<br>    protocol       = string<br>    default_action = map(string)<br>  })</pre> | <pre>{<br>  "default_action": {<br>    "type": "redirect"<br>  },<br>  "port": 80,<br>  "protocol": "HTTP"<br>}</pre> | no |
| <a name="input_lb_listener_https"></a> [lb\_listener\_https](#input\_lb\_listener\_https) | n/a | <pre>object({<br>    port            = number<br>    protocol        = string<br>    certificate_arn = string<br>    ssl_policy      = string<br>    default_action  = map(string)<br>  })</pre> | <pre>{<br>  "certificate_arn": "",<br>  "default_action": {<br>    "type": "forward"<br>  },<br>  "port": 443,<br>  "protocol": "HTTPS",<br>  "ssl_policy": "ELBSecurityPolicy-TLS-1-2-2017-01"<br>}</pre> | no |
| <a name="input_lb_target_group"></a> [lb\_target\_group](#input\_lb\_target\_group) | n/a | <pre>object({<br>    port        = number<br>    protocol    = string<br>    target_type = string<br>  })</pre> | <pre>{<br>  "port": 80,<br>  "protocol": "HTTP",<br>  "target_type": "ip"<br>}</pre> | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | n/a | <pre>object({<br>    internal           = bool<br>    load_balancer_type = string<br>    access_logs_bucket = string<br>    access_logs_prefix = string<br>  })</pre> | <pre>{<br>  "access_logs_bucket": "",<br>  "access_logs_prefix": "",<br>  "internal": false,<br>  "load_balancer_type": "application"<br>}</pre> | no |
| <a name="input_security_group_rules_alb"></a> [security\_group\_rules\_alb](#input\_security\_group\_rules\_alb) | n/a | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb"></a> [alb](#output\_alb) | n/a |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | n/a |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | n/a |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | n/a |
| <a name="output_ecr_repository_app"></a> [ecr\_repository\_app](#output\_ecr\_repository\_app) | n/a |
| <a name="output_ecr_repository_web"></a> [ecr\_repository\_web](#output\_ecr\_repository\_web) | n/a |
| <a name="output_ecs_service"></a> [ecs\_service](#output\_ecs\_service) | n/a |
| <a name="output_ecs_sg_id"></a> [ecs\_sg\_id](#output\_ecs\_sg\_id) | n/a |
| <a name="output_lb_listener_http"></a> [lb\_listener\_http](#output\_lb\_listener\_http) | n/a |
| <a name="output_lb_listener_https"></a> [lb\_listener\_https](#output\_lb\_listener\_https) | n/a |
| <a name="output_lb_target_group_blue"></a> [lb\_target\_group\_blue](#output\_lb\_target\_group\_blue) | n/a |
| <a name="output_lb_target_group_green"></a> [lb\_target\_group\_green](#output\_lb\_target\_group\_green) | n/a |

## Example

```
module "service_webapp" {
  source = "../example/tf-m-templates/modules/aws/service/fargate/webapp"

  common = {
    project      = "example"
    environment  = "dev"
    service_name = "webapp"
    region       = "ap-northeast-1"
  }

  vpc_id         = module.network.vpc_id
  alb_subnet_ids = module.network.public_subnet_ids
  ecs_subnet_ids = module.network.private_subnet_ids[0]

  security_group_rules_alb = ["0.0.0.0/0"]

  load_balancer = {
    internal           = false
    load_balancer_type = "application"
    access_logs_bucket = module.global.alblog_bucket.id
    access_logs_prefix = "WEBAPP-ALB"
  }

  lb_target_group = {
    protocol    = "HTTP"
    port        = 80
    target_type = "ip"
  }

  lb_health_check = {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
    matcher             = "200"
  }

  lb_listener_http = {
    port     = 80
    protocol = "HTTP"
    default_action = {
      type = "redirect"
    }
  }

  lb_listener_https = {
    port            = 443
    protocol        = "HTTPS"
    ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
    certificate_arn = "arn:aws:acm:ap-northeast-1:xxxxxxxxxxxx:certificate/xxxxxx"
    default_action = {
      type = "forward"
    }
  }

  ecr_repository_web = {
    image_tag_mutability          = "MUTABLE"
    scan_on_push                  = true
    lifecycle_policy_count_number = 15
  }

  ecr_repository_app = {
    image_tag_mutability          = "MUTABLE"
    scan_on_push                  = true
    lifecycle_policy_count_number = 15
  }

  ecs_task = {
    cpu          = 256
    memory       = 512
    network_mode = "awsvpc"
  }

  ecs_cluster_id   = module.service_global.ecs_cluster.id
  ecs_cluster_name = module.service_global.ecs_cluster.name

  ecs_service = {
    launch_type                = "FARGATE"
    platform_version           = "1.4.0"
    desired_count              = 1
    deployment_controller_type = "CODE_DEPLOY"
    //deployment_controller_type = "ECS"
  }

  appautoscaling_target = {
    max_capacity       = 1
    min_capacity       = 1
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace  = "ecs"
  }

  appautoscaling_policy = {
    policy_type            = "TargetTrackingScaling"
    predefined_metric_type = "ECSServiceAverageCPUUtilization"
    statistic              = "Maximum"
    target_value           = 40
    disable_scale_in       = false
    scale_in_cooldown      = 300
    scale_out_cooldown     = 300
  }

  ecs_log_retention_in_days = 14
}
```