/**
# OutPuts
*/

output "lb_this" {
  value = aws_lb.this
}

output "security_group_ecs" {
  value = aws_security_group.ecs
}

output "ecr_repository_web" {
  value = aws_ecr_repository.web
}

output "ecr_repository_app" {
  value = aws_ecr_repository.app
}

output "ecs_service_this" {
  value = aws_ecs_service.this
}

output "lb_target_group_blue" {
  value = aws_lb_target_group.blue
}

output "lb_target_group_green" {
  value = aws_lb_target_group.green
}

output "lb_listener_http" {
  value = aws_lb_listener.http
}

output "lb_listener_https" {
  value = aws_lb_listener.https
}