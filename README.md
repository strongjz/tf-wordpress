Terraform scripts for building out a Base VPC, OpenVPN, Subnets, Routes, Routing Tables, VPC Endpoint, Cloudtrail and IAM groups for installing and running Wordpress.

# Prereq

Need to Create your own AWS EC2 key file, named wordpress-demo-key.pem and placed in ./files/wordpress-demo-key.pem


### Tested with

Terraform v0.9.11

GNU Make 3.81

Ansible 2.3.2.0


Need to create a secrets.tfvars file with these vars

aws_profile - name of the AWS profile you using. Terraform code assumes you are running under an AWS profile

openvpn_admin_pw - open vpn admin password

admin_ip - IP to allow admin access to certain features

Once the the key is created and the vars are updated, run ```make all```

### Makefile

all: check clean get plan apply

check: Checks if terraform is installed

clean: Deletes the .terraform dir

get: Gets all the terraform modules

plan: Terraform plan

apply: Terraform apply

destroy: Deletes everything in Terraform

#Ansible role base on Ansible Example

https://github.com/ansible/ansible-examples/tree/master/wordpress-nginx

This terraform creates

1 OpenVPN Access server

3 Public Subnet

3 Private Subnets

3 Database Subnets

All Subnets, NACL's and Route tables for all the subnets

1 VPC
1 Wordpress instances

S3 bucket for cloudtrail

Nat Gateway

Internet gateway
