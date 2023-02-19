/** 
# NOTE: CloudWatch Metric Filter
*/

resource "aws_cloudwatch_log_metric_filter" "log_metric_filter" {
  for_each = { for log_group in var.log_group_error_filter : log_group.log_filter_name => log_group }

  name           = "${var.common.project}-${each.value.log_filter_name}-${var.common.environment}-log-filter"
  pattern        = each.value.pattern
  log_group_name = each.value.log_group_name

  metric_transformation {
    name      = "${var.common.project}-${each.value.log_filter_name}-${var.common.environment}-log-detection"
    namespace = "LogFilter"
    value     = "1"
  }
}