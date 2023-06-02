resource "aws_kinesis_firehose_delivery_stream" "logger" {
  name        = "${var.common.project}-${var.common.environment}-ses-log-firehose"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.logger.arn

    buffering_size     = 5
    buffering_interval = 300

    dynamic_partitioning_configuration {
      enabled = "false"
    }

    prefix              = ""
    error_output_prefix = "error/{firehose:error-output-type}/"
  }
}