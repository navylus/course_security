provider "aws" {
  region  = "eu-west-3"
  version = "~> 2.11.0"
}

data "aws_vpc" "main" {
  tags {
    Name = "mainVPC"
  }
}

data "aws_instance" "bastion" {
  instance_tags {
    Name = "EC2 BASTION"
  }
}

resource "aws_subnet" "main" {
  availability_zone = "eu-west-3a"
  vpc_id            = "${data.aws_vpc.main.id}"
  cidr_block        = "172.2.1.0/24"

  tags = {
    Name = "subnetDB1"
  }
}

resource "aws_subnet" "second" {
  availability_zone = "eu-west-3a"
  vpc_id            = "${data.aws_vpc.main.id}"
  cidr_block        = "172.2.2.0/24"

  tags = {
    Name = "subnetDB2"
  }
}

resource "aws_subnet" "third" {
  availability_zone = "eu-west-3c"
  vpc_id            = "${data.aws_vpc.main.id}"
  cidr_block        = "172.2.3.0/24"

  tags = {
    Name = "subnetDB3"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.2.0.0/16"]
  }

  tags = {
    Name = "allow_all"
  }
}

resource "aws_security_group" "ingress-all-ssh" {
  name   = "ingress-all-ssh"
  vpc_id = "${data.aws_vpc.main.id}"

  ingress {
    cidr_blocks = ["${data.aws_vpc.main.cidr_block}"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6"
  instance_class         = "db.t2.micro"
  name                   = "${var.nameDB}"
  username               = "${var.userDB}"
  password               = "${var.passDB}"
  availability_zone      = "eu-west-3a"
  db_subnet_group_name   = "${aws_db_subnet_group.main.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  skip_final_snapshot    = true
}

data "aws_ami" "gogit" {
  most_recent = true
  owners      = ["self"]
  most_recent = true
  name_regex  = "^packer-example-[0-9]*"
}

resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.gogit.id}"
  instance_type          = "t2.micro"
  key_name               = "deployer-key"
  subnet_id              = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${aws_security_group.ingress-all-ssh.id}"]

  tags = {
    Name = "EC2 GOGIT"
  }

  connection {
    // bastion
    bastion_host        = "${data.aws_instance.bastion.public_dns}"
    bastion_host_key    = "deployer-key"
    bastion_private_key = "${file("~/.ssh/amazon_pub")}"
    bastion_user        = "ubuntu"

    // ursho
    type        = "ssh"
    user        = "ubuntu"
    host        = "${aws_instance.web.private_ip}"
    private_key = "${file("~/.ssh/amazon_pub")}"
    timeout     = "30s"
  }

  provisioner "file" {
    source      = "./files/config.json"
    destination = "/home/ubuntu/config/config.json"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl start ursho.service",
      "sudo systemctl enable ursho.service",
    ]
  }
}

data "template_file" "init" {
  template = "${file("${path.module}/files/config.json")}"

  vars = {
    hostDB = "${aws_db_instance.default.endpoint}"
    userDB = "${var.userDB}"
    passDB = "${var.passDB}"
    nameDB = "${var.nameDB}"
  }
}
