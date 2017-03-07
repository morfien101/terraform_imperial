# Create the SQS START
output "aws_sns_topic_autoscale_notifications_arn" {
  value = "${aws_sns_topic.autoscale_notifications.arn}"
}
# Create the SQS END
