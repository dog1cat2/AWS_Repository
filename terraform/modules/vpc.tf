###########################################################################
# 작업자 : 진민
# 내용 :  vpc 구성 코드
# 진행도 : 복사만 한 형태 -> 수정 필요
###########################################################################

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.project_name}-${var.environment}-natgw1"
  }
}

resource "aws_eip" "nat_gateway" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.project_name}-${var.environment}-natgw1-eip"
  }
}

# Subnet
## public-subnet1
### NAT Gateway & Bastion Host
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-2a"
  cidr_block              = "${var.cidr_public}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet"
  }
}


## private1-subnet
resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-2a"
  cidr_block              = "${var.cidr_private1}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private1-subnet"
  }
}

## private2-subnet
resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-2c"
  cidr_block              = "${var.cidr_private2}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private2-subnet"
  }
}



## DB Subnet Group
resource "aws_db_subnet_group" "db-subnet-group" {
  name = "hangeun-db-subnet-group"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]
    # 서브넷에 이미 소속 VPC, AZ 정보를 입력하여 생성하였기 때문에, 서브넷 id만 나열해주면 subnet group 생성
}

# Route table
## public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rtb"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}


## private1~2
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rtb"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private1" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}


# NACL
## public
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public.id]

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-nacl"
  }
}

## private1~2
resource "aws_network_acl" "private1" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private1-nacl"
  }
}
