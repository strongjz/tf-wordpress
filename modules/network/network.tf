#--------------------------------------------------------------
# This module creates all networking resources
#--------------------------------------------------------------
module "vpc" {
  source = "./vpc"

  name   = "${var.name}-vpc"
  cidr   = "${var.vpc_cidr}"
  region = "${var.region}"
  env    = "${var.env}"
}

module "public_subnet" {
  source = "./public_subnet"

  name   = "${var.name}-public"
  vpc_id = "${module.vpc.vpc_id}"
  cidrs  = "${var.public_subnets}"
  azs    = "${var.azs}"
  env    = "${var.env}"
}

module "nat" {
  source = "./nat"

  name              = "${var.name}-nat"
  azs               = "${var.azs}"
  public_subnet_ids = "${module.public_subnet.subnet_ids}"
}

module "private_subnet" {
  source = "./private_subnet"
  env    = "${var.env}"
  name   = "${var.name}-private"
  vpc_id = "${module.vpc.vpc_id}"
  cidrs  = "${var.private_subnets}"
  azs    = "${var.azs}"

  nat_gateway_ids = "${module.nat.nat_gateway_ids}"
  vpc_s3_endpoint = "${module.vpc.vpc_s3_endpoint}"
}

module "database_subnet" {
  source = "./database_subnet"
  env    = "${var.env}"
  name   = "${var.name}-database-private"
  vpc_id = "${module.vpc.vpc_id}"
  cidrs  = "${var.database_subnets}"
  azs    = "${var.azs}"

  nat_gateway_ids = "${module.nat.nat_gateway_ids}"
  vpc_s3_endpoint = "${module.vpc.vpc_s3_endpoint}"
}

/*
module "openvpn" {
  source = "./openvpn"

  name              = "${var.name}-openvpn"
  vpc_id            = "${module.vpc.vpc_id}"
  vpc_cidr          = "${module.vpc.vpc_cidr}"
  public_subnet_ids = "${module.public_subnet.subnet_ids}"
  key_name          = "${var.key_name}"

  users              = "${var.users}"
  instance_type      = "${var.openvpn_instance_type}"
  openvpn_user       = "${var.openvpn_user}"
  openvpn_admin_user = "${var.openvpn_admin_user}"
  openvpn_admin_pw   = "${var.openvpn_admin_pw}"
  vpn_cidr           = "${var.openvpn_cidr}"
  admin_ip           = "${var.admin_ip}"
}
*/

resource "aws_network_acl" "acl" {
  vpc_id = "${module.vpc.vpc_id}"

  subnet_ids = [
    "${concat(split(",", module.public_subnet.subnet_ids), split(",", module.private_subnet.subnet_ids))}",
  ]

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "${var.name}-${var.env}-all"
  }
}
