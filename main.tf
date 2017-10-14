module "s3" {
  source     = "./modules/s3/"
  aws_region = "${var.aws_region}"
  name       = "${var.name}"
}

module "cloudtrail" {
  source               = "./modules/cloudtrail/"
  cloudtrail_bucket_id = "${module.s3.cloudtrail_bucket_id}"
  name                 = "${var.name}"
}

#network
module "network" {
  source = "./modules/network/"
  region = "${var.aws_region}"
  env    = "${var.env}"

  name             = "${var.name}"
  vpc_cidr         = "${var.vpc_cidr}"
  azs              = "${var.azs}"
  region           = "${var.aws_region}"
  private_subnets  = "${var.private_subnets}"
  public_subnets   = "${var.public_subnets}"
  database_subnets = "${var.database_subnets}"

  openvpn_instance_type = "${var.openvpn_instance_type}"
  users                 = "${var.users}"
  openvpn_user          = "${var.openvpn_user}"
  openvpn_admin_user    = "${var.openvpn_admin_user}"
  openvpn_admin_pw      = "${var.openvpn_admin_pw}"
  openvpn_cidr          = "${var.openvpn_cidr}"
  key_name              = "${var.key_name}"
  admin_ip              = "${var.admin_ip}"
}

module "wordpress" {
  source = "./modules/wordpress"

  region                          = "${var.aws_region}"
  env                             = "${var.env}"
  vpn_subnets                     = "${var.openvpn_cidr}"
  key_name                        = "${var.key_name}"
  name                            = "${var.name}"
  public_subnets                  = "${var.public_subnets}"
  admin_ip                        = "${var.admin_ip}"
  public_subnet_ids               = "${module.network.public_subnet_ids}"
  vpc_id                          = "${module.network.vpc_id}"
  wordpress_instance_type         = "${var.wordpress_instance_type}"
  vpc_cidr                        = "${var.vpc_cidr}"
  private_subnets                 = "${var.private_subnets}"
  private_subnet_ids              = "${module.network.private_subnet_ids}"
  database_subnets                = "${var.database_subnets}"
  database_subnet_ids             = "${module.network.database_subnet_ids}"
  wordpressdatabase_instance_type = "${var.wordpressdatabase_instance_type}"
}
