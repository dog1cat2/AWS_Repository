###########################################################################
# 작업자 : 진민
# 내용 :  Security Group 구성 코드
# 진행도 : 완성
###########################################################################


########################################################################
# EC2 SG
########################################################################


########################################################
## Bation EC2
########################################################
resource "aws_security_group" "hangeun_bastion_ec2"{
    name        = "${var.project_name}-${var.environment}-bastion-sg"
    description = "for bastion ec2"
    vpc_id      = aws_vpc.vpc.id

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-sg"
  }
}

################################################
### Connected for RDS
################################################
resource "aws_security_group" "hangeun_bastion_from_rds" {
  name = "${var.project_name}-${var.environment}-connection-bastion-rds-sg"
  description = "bastion ec2 connect RDS"
  vpc_id = aws_vpc.vpc.id  
}

resource "aws_security_group_rule" "bastion_from_rds" {
  type = "egress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id        = aws_security_group.hangeun_bastion_from_rds.id
  source_security_group_id = aws_security_group.hangeun_rds_from_bastion.id
  lifecycle {
    create_before_destroy = true
  }
}

########################################################################
# RDS SG
########################################################################
resource "aws_security_group" "hangeun_rds"{
    name = "${var.project_name}-${var.environment}-rds-sg"
    description = "for rds"
    vpc_id = aws_vpc.vpc.id

    egress  {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
          Name = "${var.project_name}-${var.environment}-rds-sg"
    }
}
#########################################################
## Connected for BationEC2
#########################################################
resource "aws_security_group" "hangeun_rds_from_bastion" {
  name = "${var.project_name}-${var.environment}-connection-rds-bation-sg"
  description = "bastion ec2 connect RDS"
  vpc_id = aws_vpc.vpc.id  
}
resource "aws_security_group_rule" "rds_from_bastion"{
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = aws_security_group.hangeun_rds_from_bastion.id
  source_security_group_id = aws_security_group.hangeun_bastion_from_rds.id
  lifecycle {
    create_before_destroy = true
  }
}

