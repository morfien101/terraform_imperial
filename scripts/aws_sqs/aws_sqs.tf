variable "vpc_region" {}

provider "aws" {
    region = "${var.vpc_region}"
}

# Create the SNS/SQS START
resource "aws_sns_topic" "autoscale_notifications" {
    name = "autoscale_notifications_imperial"
    display_name = "autoscale_notifications_imperial"
}

resource "aws_sqs_queue" "autoscale_watcher" {
    name = "autoscale_watcher_imperial"
    visibility_timeout_seconds = 120
}

resource "aws_sqs_queue_policy" "autoscale_watcher_policy" {
    queue_url = "${aws_sqs_queue.autoscale_watcher.id}"
    policy = <<POLICY
    {
    "Version": "2012-10-17",
    "Id": "${aws_sqs_queue.autoscale_watcher.arn}/SQSPolicy",
    "Statement": [
        {
            "Sid": "123456789",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "SQS:SendMessage",
            "Resource": "${aws_sqs_queue.autoscale_watcher.arn}",
            "Condition": {
                "ArnEquals": {
                    "aws:SourceArn": "${aws_sns_topic.autoscale_notifications.arn}"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_sns_topic_subscription" "autoscale_notifications_sqs" {
    topic_arn = "${aws_sns_topic.autoscale_notifications.arn}"
    protocol = "sqs"
    endpoint = "${aws_sqs_queue.autoscale_watcher.arn}"

}
# Create the SNS/SQS END
