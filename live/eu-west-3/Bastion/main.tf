provider "aws" {
  region  = "eu-west-3"
  version = "~> 2.11.0"
}

resource "aws_vpc" "main" {
  cidr_block           = "172.2.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "mainVPC"
  }
}

resource "aws_subnet" "subnet-bastion" {
  availability_zone = "eu-west-3a"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.2.8.0/24"

  tags = {
    Name = "subnetBastion"
  }
}

resource "aws_security_group" "bastion-all-ssh" {
  name   = "bastion-all-ssh"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "gogit" {
  most_recent = true
  owners      = ["self"]
  most_recent = true
  name_regex  = "^packer-example-[0-9]*"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${file("~/.ssh/amazon_pub.pub")}"
}

resource "aws_instance" "bastion" {
  ami                    = "${data.aws_ami.gogit.id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.deployer.key_name}"
  subnet_id              = "${aws_subnet.subnet-bastion.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion-all-ssh.id}"]

  tags = {
    Name = "EC2 BASTION"
  }
}

resource "aws_eip" "ip-bastion-env" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true
}

resource "aws_internet_gateway" "bastion-env-gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "bastion-env-gw"
  }
}

resource "aws_route_table" "route-table-bastion-env" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.bastion-env-gw.id}"
  }

  tags {
    Name = "bastion-env-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-bastion.id}"
  route_table_id = "${aws_route_table.route-table-bastion-env.id}"
}
