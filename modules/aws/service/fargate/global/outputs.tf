/**
# ECS
*/
output "ecs_cluster" {
  value = aws_ecs_cluster.cluster
}

/**
# S3
*/
output "alblog_bucket" {
  value = aws_s3_bucket.alblog
}