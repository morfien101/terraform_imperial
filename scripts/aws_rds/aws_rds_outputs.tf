# Create the RDS START
output "aws_db_instance_db1_address" {
  value = "${aws_db_instance.db1.address}"
}

output "aws_db_instance_db1_name" {
  value = "${aws_db_instance.db1.name}"
}
 output "aws_security_group_rds_id" {
   value = "${aws_security_group.rds.id}"
}
# Create the RDS END
