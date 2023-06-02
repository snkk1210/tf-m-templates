/**
# NOTE: Kinesis Data Firehose IAM
*/
data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "firehose_to_s3" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

resource "aws_iam_role" "firehose_role" {
  name               = "${var.common.project}-${var.common.environment}-ses-log-firehose-role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

resource "aws_iam_policy" "firehose_to_s3" {
  name   = "${var.common.project}-${var.common.environment}-firehose-to-s3-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.firehose_to_s3.json
}

resource "aws_iam_role_policy_attachment" "firehose_to_s3" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_to_s3.arn
}

/**
# NOTE: SES IAM
*/
data "aws_iam_policy_document" "ses_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ses_to_firehose" {
  statement {
    actions = [
      "firehose:PutRecordBatch"
    ]

    resources = [
      "${aws_kinesis_firehose_delivery_stream.logger.arn}",
    ]
  }
}

resource "aws_iam_role" "ses_role" {
  name               = "${var.common.project}-${var.common.environment}-ses-log-ses-role"
  assume_role_policy = data.aws_iam_policy_document.ses_assume_role.json
}

resource "aws_iam_policy" "ses_to_firehose" {
  name   = "${var.common.project}-${var.common.environment}-ses-to-firehose-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.ses_to_firehose.json
}

resource "aws_iam_role_policy_attachment" "ses_to_firehose" {
  role       = aws_iam_role.ses_role.name
  policy_arn = aws_iam_policy.ses_to_firehose.arn
}