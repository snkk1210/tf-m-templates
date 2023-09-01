/**
# OutPut
*/
output "alb" {
  value = aws_lb.alb
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs.id
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.log.name
}

output "ecr_repository_web" {
  value = aws_ecr_repository.web
}

output "ecr_repository_app" {
  value = aws_ecr_repository.app
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

output "lb_listener_http" {
  value = aws_lb_listener.listener_http
}

output "lb_listener_https" {
  value = aws_lb_listener.listener_https
}