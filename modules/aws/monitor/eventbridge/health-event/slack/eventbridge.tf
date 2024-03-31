/** 
# EventBridge
*/

resource "aws_cloudwatch_event_rule" "this" {
  name        = "${var.common.project}-${var.common.environment}-health-event-slack-notify-rule${var.sfx}"
  description = "${var.common.project}-${var.common.environment}-health-event-slack-notify-rule${var.sfx}"

  event_pattern = <<EOF
{
  "detail-type": [
      "AWS Health Event"
  ],
  "source": [
      "aws.health"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "${var.common.project}-${var.common.environment}-health-event-slack-notify-sns-topic${var.sfx}"
  arn       = aws_sns_topic.this.arn
}