# Create the ASG and Web Servers START

output "aws_elb_webserver_elb_dns_name" {
    value = "${aws_elb.webserver-elb.dns_name}"
}

# Create the ASG and Web Servers END
