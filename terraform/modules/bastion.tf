###########################################################################
# 작업자 : 진민
# 내용 :  Bation EC2 구성 코드
# 진행도 : 완료
###########################################################################


# EC2
resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-eip"
  }
}

resource "aws_instance" "bastion" {
  ami = "${var.bastion_ami}"
  instance_type = "${var.bastion_instance_type}"
  vpc_security_group_ids = [aws_security_group.hangeun_bastion_ec2.id, aws_security_group.hangeun_bastion_from_rds.id]
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  subnet_id = aws_subnet.public.id
  key_name = "${var.bastion_key_name}"
  disable_api_termination = true
  # User data 추가
  user_data = <<EOF
#!/bin/bash

echo "Set Up Init Server"
yum update -y

echo "STEP Install MariaDB"
yum install mariadb105
EOF
  root_block_device {
    volume_size = "${var.bastion_volume_size}"
    volume_type = "gp3"
    delete_on_termination = true
    tags = {
      Name = "${var.project_name}-${var.environment}-bastion-ec2"
    }
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-ec2"
  }
}