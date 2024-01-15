// Aurora 拡張モニタリング role
resource "aws_iam_role" "aurora_expansion_monitoring" {
  name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-aurora-expansion-monitoring-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}

// Aurora 拡張モニタリング ポリシー　アタッチ
resource "aws_iam_role_policy_attachment" "aurora_expansion_monitoring" {
  role       = aws_iam_role.aurora_expansion_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}