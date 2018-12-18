provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "test-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a"]
  public_subnets  = ["10.0.101.0/24"]
  
  enable_nat_gateway = false
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy     = "default"
  map_public_ip_on_launch = true # <= aws_subnet

  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "test-vpc"
  }
}

module "kafka_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/kafka"
  name = "kafka"
  vpc_id = "${module.vpc.vpc_id}"
  ingress_cidr_blocks = ["0.0.0.0/0"] # <= Specify ingress port for inbound rules
  egress_cidr_blocks  = ["0.0.0.0/0"]

}

resource "aws_security_group" "ssh" {
  name        = "ssh_security_group"
  description = "Allow ssh traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "ssh_security_group"
  }
}

resource "aws_security_group" "zookeeper" {
  name        = "zookeeper_security_group"
  description = "Allow zookeeper traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  # port 31995 as well maybe
  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 31995
    to_port     = 31995
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "zookeeper_security_group"
  }
}

