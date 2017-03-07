variable "vpc_region" {}

variable "tfstate_bucket" {}
variable "vpc_state_key" {}

variable "tag_owner" {}

variable "rds_size" {}
variable "rds_username" {}
variable "rds_password" {}
variable "rds_access_cidr" {}

provider "aws" {
    region = "${var.vpc_region}"
}

data "terraform_remote_state" "vpc" {
	backend = "s3"
	config {
		region = "${var.vpc_region}"
		bucket = "${var.tfstate_bucket}"
		key = "${var.vpc_state_key}"
	}
}

# Create the RDS START
resource "aws_db_subnet_group" "rds_subnets" {
    name = "main"
    subnet_ids = ["${split(",",data.terraform_remote_state.vpc.aws_subnets_private)}"]
    tags {
        Name = "RDS Subnets"
    }
}

resource "aws_security_group" "rds" {
    name="rds_access"
    description="Allow access to MySQL RDS"
    vpc_id="${data.terraform_remote_state.vpc.aws_vpc_vpc1_id}"
    egress {
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
    }
    ingress {
        from_port=3306
        to_port=3306
        protocol="tcp"
        cidr_blocks=["${var.rds_access_cidr}"]
    }
}

resource "aws_db_instance" "db1" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.6.27"
  instance_class       = "${var.rds_size}"
  name                 = "mydb"
  username             = "${var.rds_username}"
  password             = "${var.rds_password}"
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnets.name}"
  parameter_group_name = "default.mysql5.6"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
}
# Create the RDS END
