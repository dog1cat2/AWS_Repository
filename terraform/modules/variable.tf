###########################################################################
# 작업자 : 진민
# 내용 :  사용 변수에 대한 코드
# 진행도 : 변수 추가 외에는 완료
###########################################################################



# Project Name
variable "project_name" {  }
variable "environment" {  }

# VPC
variable "cidr_vpc" {}
variable "cidr_public" {}
variable "cidr_private1" {}
variable "cidr_private2" {}

# Bastion EC2
variable "bastion_ami" {}
variable "bastion_instance_type" {}
variable "bastion_volume_size" {}
variable "bastion_key_name" {}

# RDS
variable "allocated_storage" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "username" {}
variable "password" {}
variable "skip_final_snapshot" {}
variable "storage_encrypted" {}
variable "port" {}
