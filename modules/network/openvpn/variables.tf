variable "name" {
  default = "openvpn"
}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "public_subnet_ids" {}

variable "key_name" {}

variable "users" {}

variable "instance_type" {}

variable "openvpn_user" {}

variable "openvpn_admin_user" {}

variable "openvpn_admin_pw" {}

variable "vpn_cidr" {}

variable "admin_ip" {}

variable "user_count" {
  type = "map"

  default = {
    "2"   = "fe8020db-5343-4c43-9e65-5ed4a825c931"
    "10"  = "8fbe3379-63b6-43e8-87bd-0e93fd7be8f3"
    "25"  = "23223b90-d61f-472a-b732-f2b98e6fa3fb"
    "50"  = "bbff26cd-b407-44a2-a7ef-70b8971391f1"
    "100" = "7091ef09-bad5-4f1d-9596-0ddf93d97793"
    "250" = "aac3a8a3-2823-483c-b5aa-60022894b89d"
  }

  description = "Maps to OpenVPN Access Server Product IDs"
}
