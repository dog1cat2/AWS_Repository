###########################################################################
# 작업자 : 진민
# 내용 :  MariaDB for RDS 구성 코드
# 진행도 : SG 부분에서 수정 필요
###########################################################################

resource "aws_db_instance" "hangeun-db" {
  # RDS 사양
  allocated_storage = "${var.allocated_storage}"
  engine = "${var.engine}"
  engine_version = "${var.engine_version}"
  instance_class = "${var.instance_class}"
  username = "${var.username}"
  password = "${var.password}"
  skip_final_snapshot = "${var.skip_final_snapshot}"
  # 네트워크
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.hangeun_rds.id, aws_security_group.hangeun_rds_from_bastion.id]
}
