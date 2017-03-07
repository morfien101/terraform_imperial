output "aws_vpc_vpc1_id" {
    value = "${aws_vpc.vpc1.id}"
}

output "aws_subnets_private" {
  value = "${join(",",aws_subnet.private.*.id)}"
}

output "aws_subnets_public" {
  value = "${join(",",aws_subnet.public.*.id)}"
}
