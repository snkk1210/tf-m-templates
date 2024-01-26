/**
# Isolated Sunbet
*/
resource "aws_subnet" "isolated_1a" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.24.0/22"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.common.project}-${var.common.environment}-isolated-subnet-1a${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_subnet" "isolated_1c" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.28.0/22"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.common.project}-${var.common.environment}-isolated-subnet-1c${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_subnet" "isolated_1d" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.32.0/22"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.common.project}-${var.common.environment}-isolated-subnet-1d${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

/** 
# Route Table ( Isolated )
*/
resource "aws_route_table" "isolated" {
  vpc_id = aws_vpc.common.id
  
  tags = {
    Name = "${var.common.project}-${var.common.environment}-isolated-rt${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_route_table_association" "isolated_1a" {
  subnet_id      = aws_subnet.isolated_1a.id
  route_table_id = aws_route_table.isolated.id
}

resource "aws_route_table_association" "isolated_1c" {
  subnet_id      = aws_subnet.isolated_1c.id
  route_table_id = aws_route_table.isolated.id
}

resource "aws_route_table_association" "isolated_1d" {
  subnet_id      = aws_subnet.isolated_1d.id
  route_table_id = aws_route_table.isolated.id
}