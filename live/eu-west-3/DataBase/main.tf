provider "aws" {
  region = "eu-west-3"
  version = "~> 2.11.0"
}

resource "aws_vpc" "main" {
  cidr_block       = "172.2.0.0/16"

  tags = {
    Name = "mainVPC"
  }
}

resource "aws_subnet" "main" {
  availability_zone = "eu-west-3a"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.2.1.0/24"

  tags = {
    Name = "subnetDB"
  }
}

resource "aws_subnet" "second" {
  availability_zone = "eu-west-3a"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.2.2.0/24"

  tags = {
    Name = "subnetDB"
  }
}
resource "aws_subnet" "third" {
  availability_zone = "eu-west-3c"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.2.3.0/24"

  tags = {
    Name = "subnetDB"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"
 ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }
  tags = {
    Name = "allow_all"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = ["${aws_subnet.main.id}", "${aws_subnet.second.id}", "${aws_subnet.third.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "dbcourse"
  username             = "navylus"
  password             = "justarandompass"
  parameter_group_name = "default.mysql5.7"
  availability_zone    = "eu-west-3a"
  db_subnet_group_name = "${aws_db_subnet_group.main.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  }
