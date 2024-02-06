/** 
# NOTE: CloudWatch Metric Filter
*/

resource "aws_cloudwatch_log_metric_filter" "log_metric_filter" {
  for_each = { for filter in var.log_metric_filters : filter.log_filter_name => filter }

  name           = "${var.common.project}-${each.value.log_filter_name}-${var.common.environment}-log-filter"
  pattern        = each.value.pattern
  log_group_name = each.value.log_group_name

  metric_transformation {
    name      = "${var.common.project}-${each.value.log_filter_name}-${var.common.environment}-log-detection"
    namespace = "LogFilter"
    value     = "1"
  }
}