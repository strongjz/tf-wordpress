variable "aws_profile" {}

variable "aws_region" {}

variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "name" {
  default = ""
}

variable "aws_account" {
  default = ""
}

variable "wordpress_instance_type" {}
variable "wordpressdatabase_instance_type" {}

#network
variable "vpc_cidr" {}

variable "azs" {}

variable "region" {}

variable "private_subnets" {}

variable "public_subnets" {}

variable "database_subnets" {}

variable "key_name" {}

variable "openvpn_instance_type" {}

variable "openvpn_user" {}

variable "openvpn_admin_user" {}

variable "openvpn_admin_pw" {}

variable "openvpn_cidr" {}

variable "users" {}

variable "admin_ip" {}

variable "env" {}
