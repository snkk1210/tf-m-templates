/**
# Job Queue For Batch
*/
resource "aws_batch_job_queue" "batch_job_queue" {
  name     = "${var.common.project}-${var.common.environment}-${var.common.service_name}-batch-queue"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.batch_environment.arn,
  ]
}