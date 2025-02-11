# 自身の Account ID を取得
data "aws_caller_identity" "self" {}
data "aws_elb_service_account" "self" {}