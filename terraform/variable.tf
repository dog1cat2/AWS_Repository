###########################################################################
# 작업자 : 진민
# 내용 :  사용 변수에 대한 코드
# 진행도 : 변수 추가 외에는 완료
###########################################################################



# Project Name
variable "project_name" { default = "hangeun" }
variable "environment" { default = "dev" }

# VPC
variable "cidr_vpc" {
    default = "10.0.0.0/16"
}
variable "cidr_public" {
    default = "10.0.0.0/24"
}
variable "cidr_private1" {
    default = "10.0.1.0/24"
}
variable "cidr_private2" {
    default = "10.0.2.0/24"
}

# Bastion EC2
variable "bastion_ami" {
  default = "ami-0462a914135d20297"
}
variable "bastion_instance_type" {
  default = "t3.micro"
}
variable "bastion_volume_size" {
  default = 8
}
variable "bastion_key_name" {
  default = "hangeun-key"
}

# RDS
variable "allocated_storage" { default = 8}
variable "engine" {default = "mariadb"}
variable "engine_version" {default = "10.6"}
variable "instance_class" {default = "db.t3.micro"}
variable "username" {default = "HANGEUN"}
variable "password" {default = "hangeun00!"}
variable "storage_encrypted" {default = false}
variable "port" {default = 3306}
variable "skip_final_snapshot" { default = true}
