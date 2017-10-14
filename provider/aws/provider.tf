variable "aws_profile" {}

variable "aws_region" {}

provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}
