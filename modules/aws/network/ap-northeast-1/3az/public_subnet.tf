/**
# Public Sunbet
*/
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.0.0/22"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
  tags = {
    Name = "${var.common.project}-${var.common.environment}-public-subnet-1a${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.4.0/22"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "${var.common.project}-${var.common.environment}-public-subnet-1c${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.8.0/22"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1d"
  tags = {
    Name = "${var.common.project}-${var.common.environment}-public-subnet-1d${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

/**
# Internet Gateway
*/
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.common.project}-${var.common.environment}-igw${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

/** 
# Route Table ( Public )
*/
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.common.project}-${var.common.environment}-public-rt${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_1d" {
  subnet_id      = aws_subnet.public_1d.id
  route_table_id = aws_route_table.public_route_table.id
}