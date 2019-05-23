resource "aws_eip" "ip-test-env" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

data "aws_internet_gateway" "test-env-gw" {
  filter {
    name   = "tag:Name"
    values = ["bastion-env-gw"]
  }
}

resource "aws_route_table" "route-table-test-env" {
  vpc_id = "${data.aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${data.aws_internet_gateway.test-env-gw.id}"
  }

  tags {
    Name = "test-env-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.route-table-test-env.id}"
}
