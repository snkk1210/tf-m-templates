resource "aws_ses_configuration_set" "logger" {
  name = "${var.common.project}-${var.common.environment}-ses-log-configuration-set"
}

resource "aws_ses_event_destination" "logger" {
  name                   = "${var.common.project}-${var.common.environment}-ses-log-destination-kinesis"
  configuration_set_name = aws_ses_configuration_set.logger.name
  enabled                = true
  matching_types = [
    "bounce",
    "send",
    "reject",
    "complaint",
    "delivery",
    "open"
  ]

  kinesis_destination {
    stream_arn = aws_kinesis_firehose_delivery_stream.logger.arn
    role_arn   = aws_iam_role.ses_role.arn
  }
}