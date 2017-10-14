# Create a new load balancer
resource "aws_elb" "bar" {
  name    = "${var.name}-elb"
  subnets = ["${split(",", var.public_subnet_ids)}"]

  security_groups = [
    "${aws_security_group.wordpress_elb.id}",
  ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 200
  }

  tags {
    Name      = "${var.name}-ELB"
    Terraform = "true"
    AutoOff   = "True"
  }

  instances                   = ["${aws_instance.wordpress.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_security_group" "wordpress_elb" {
  name        = "${var.name}-elb"
  vpc_id      = "${var.vpc_id}"
  description = "wordpress elb security group"

  tags {
    Name = "${var.name}"
  }

  # For wordpress Client Web Server & Admin Web UI
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol  = -1
    from_port = 0
    to_port   = 0

    cidr_blocks = ["0.0.0.0/0"]
  }
}
