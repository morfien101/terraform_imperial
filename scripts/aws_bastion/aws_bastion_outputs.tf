# Create the BASTION START
output "aws_instance_bastion_host_public_ip" {
  value = "${aws_instance.bastion_host.public_ip}"
}

output "aws_instance_bastion_host_public_dns" {
  value = "${aws_instance.bastion_host.public_dns}"
}

output "aws_instance_bastion_host_id" {
  value = "${aws_instance.bastion_host.id}"
}

output "aws_security_group_bastion_id" {
  value = "${aws_security_group.bastion.id}"
}

# Get the sg id
# Create the BASTION END
