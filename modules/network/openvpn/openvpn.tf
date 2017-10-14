#--------------------------------------------------------------
# This module creates all resources necessary for OpenVPN
#--------------------------------------------------------------

data "aws_ami" "openvpnas" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "*${var.user_count[var.users]}*",
    ]
  }

  owners = [
    "679593333241",
  ]
}

resource "aws_security_group" "openvpn" {
  name        = "${var.name}"
  vpc_id      = "${var.vpc_id}"
  description = "OpenVPN security group"

  tags {
    Name = "${var.name}"
  }

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0

    cidr_blocks = [
      "${var.vpc_cidr}",
    ]
  }

  # For OpenVPN Client Web Server & Admin Web UI
  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    cidr_blocks = [
      "${var.admin_ip}",
    ]
  }

  ingress {
    protocol  = "udp"
    from_port = 1194
    to_port   = 1194

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    protocol  = -1
    from_port = 0
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_instance" "openvpn" {
  ami           = "${data.aws_ami.openvpnas.id}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  subnet_id     = "${element(split(",", var.public_subnet_ids), count.index)}"

  vpc_security_group_ids = [
    "${aws_security_group.openvpn.id}",
  ]

  tags {
    Name      = "${var.name}"
    Terraform = "true"
  }

  # `admin_user` and `admin_pw` need to be passed in to the appliance through `user_data`, see docs -->
  # https://docs.openvpn.net/how-to-tutorialsguides/virtual-platforms/amazon-ec2-appliance-ami-quick-start-guide/
  user_data = <<USERDATA
admin_user=${var.openvpn_admin_user}
admin_pw=${var.openvpn_admin_pw}
USERDATA
}

resource "aws_eip" "vpn" {
  vpc = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip_association" "eip_vpn" {
  instance_id   = "${aws_instance.openvpn.id}"
  allocation_id = "${aws_eip.vpn.id}"
}

output "private_ip" {
  value = "${aws_instance.openvpn.private_ip}"
}

output "public_ip" {
  value = "${aws_instance.openvpn.public_ip}"
}
