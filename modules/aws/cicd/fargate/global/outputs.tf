/**
# OutPut CI/CD Global
*/
output "artifact_bucket_id" {
  value = aws_s3_bucket.artifact.id
}