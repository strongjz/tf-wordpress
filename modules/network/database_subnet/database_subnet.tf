#--------------------------------------------------------------
# This module creates all resources necessary for a private
# subnet
#--------------------------------------------------------------

variable "name" {
  default = "database"
}

variable "vpc_id" {}

variable "cidrs" {}

variable "azs" {}

variable "nat_gateway_ids" {}

variable "vpc_s3_endpoint" {}

variable "env" {}

#private application subnets
resource "aws_subnet" "database" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(split(",", var.cidrs), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count             = "${length(split(",", var.cidrs))}"

  tags {
    Name = "${var.name}-${var.env}.${element(split(",", var.azs), count.index)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "database" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(split(",", var.cidrs))}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(split(",", var.nat_gateway_ids), count.index)}"
  }

  tags {
    Name = "${var.name}-${var.env}.${element(split(",", var.azs), count.index)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint_route_table_association" "database_s3" {
  vpc_endpoint_id = "${var.vpc_s3_endpoint}"
  route_table_id  = "${element(aws_route_table.database.*.id, count.index)}"
  count           = "${length(split(",", var.cidrs))}"
}

resource "aws_route_table_association" "database" {
  count          = "${length(split(",", var.cidrs))}"
  subnet_id      = "${element(aws_subnet.database.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.database.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

output "subnet_ids" {
  value = "${join(",", aws_subnet.database.*.id)}"
}
