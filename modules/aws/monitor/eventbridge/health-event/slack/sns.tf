/** 
# SNS
*/

// SNS 通知トピック
resource "aws_sns_topic" "this" {
  name         = "${var.common.project}-${var.common.environment}-health-event-slack-notify-sns-topic${var.sfx}"
  display_name = "${var.common.project}-${var.common.environment}-health-event-slack-notify-sns-topic${var.sfx}"
}

// SNS 通知トピック ポリシー
resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.eventbridge_to_sns.json
}

// SNS Publish ポリシー
data "aws_iam_policy_document" "eventbridge_to_sns" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.this.arn]
  }
}