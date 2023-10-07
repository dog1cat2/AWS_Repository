terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


module "dev" {
  source = "./modules"

  # prj
  project_name = var.project_name
  environment = var.environment

  # VPC
  cidr_vpc = var.cidr_vpc
  cidr_public = var.cidr_public
  cidr_private1 = var.cidr_private1
  cidr_private2 = var.cidr_private2

  # Bastion EC2
  bastion_ami           = var.bastion_ami
  bastion_instance_type = var.bastion_instance_type
  bastion_volume_size   = var.bastion_volume_size
  bastion_key_name      = var.bastion_key_name

  # RDS
  allocated_storage = var.allocated_storage
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  storage_encrypted =  var.storage_encrypted
  username = var.username
  password = var.password
  port = var.port
  skip_final_snapshot = var.skip_final_snapshot

  # Lambda

  # API Gateway

}