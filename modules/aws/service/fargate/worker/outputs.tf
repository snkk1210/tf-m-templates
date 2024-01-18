/**
# OutPut
*/
output "ecs_sg_id" {
  value = aws_security_group.ecs.id
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.log.name
}

output "ecr_repository" {
  value = aws_ecr_repository.this
}

output "ecs_service" {
  value = aws_ecs_service.main
}

output "lb_target_group_blue" {
  value = aws_lb_target_group.blue
}

output "lb_target_group_green" {
  value = aws_lb_target_group.green
}