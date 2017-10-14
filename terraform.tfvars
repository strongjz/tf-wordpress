name = "wordpress-demo"
env = "dev"
aws_region = "us-east-1"
region = "us-east-1"



#--------------------------------------------------------------
# Network
#--------------------------------------------------------------
key_name = "wordpress-demo-key"
vpc_cidr = "10.1.0.0/16"
azs = "us-east-1a,us-east-1c,us-east-1b" # AZs are region specific
private_subnets = "10.1.1.0/24,10.1.2.0/24,10.1.3.0/24" # Creating one private subnet per AZ
public_subnets = "10.1.11.0/24,10.1.12.0/24,10.1.13.0/24" # Creating one public subnet per AZ
database_subnets = "10.1.21.0/24,10.1.22.0/24,10.1.23.0/24" # Creating one public subnet per AZ

# OpenVPN - https://docs.openvpn.net/how-to-tutorialsguides/virtual-platforms/amazon-ec2-appliance-ami-quick-start-guide/
openvpn_instance_type = "t2.micro"
openvpn_user = "openvpnas"
openvpn_admin_user = "vpnadmin"
openvpn_cidr = "172.27.139.0/24"
users = "2"

#--------------------------------------------------------------
# Wordpress
#--------------------------------------------------------------

wordpress_instance_type = "t2.medium"

wordpressdatabase_instance_type = "t2.medium"
