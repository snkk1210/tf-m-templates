/**
# Nat Gateway
*/
resource "aws_eip" "eip_nat_gateway_1a" {
  count      = var.enable_private ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-eip-1a${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_eip" "eip_nat_gateway_1c" {
  count      = var.enable_private ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-eip-1c${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_eip" "eip_nat_gateway_1d" {
  count      = var.enable_private ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-eip-1d${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_nat_gateway" "nat_gateway_1a" {
  count         = var.enable_private ? 1 : 0
  allocation_id = aws_eip.eip_nat_gateway_1a[0].id
  subnet_id     = aws_subnet.public_1a.id
  depends_on    = [aws_internet_gateway.this]
  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-1a${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_nat_gateway" "nat_gateway_1c" {
  count         = var.enable_private ? 1 : 0
  allocation_id = aws_eip.eip_nat_gateway_1c[0].id
  subnet_id     = aws_subnet.public_1c.id
  depends_on    = [aws_internet_gateway.this]
  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-1c${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_nat_gateway" "nat_gateway_1d" {
  count         = var.enable_private ? 1 : 0
  allocation_id = aws_eip.eip_nat_gateway_1d[0].id
  subnet_id     = aws_subnet.public_1d.id
  depends_on    = [aws_internet_gateway.this]
  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-1d${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

/** 
# Private Subnet
*/
resource "aws_subnet" "private_1a" {
  count                   = var.enable_private ? 1 : 0
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.12.0/22"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-private-subnet-1a${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_subnet" "private_1c" {
  count                   = var.enable_private ? 1 : 0
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.16.0/22"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-private-subnet-1c${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_subnet" "private_1d" {
  count                   = var.enable_private ? 1 : 0
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.20.0/22"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-private-subnet-1d${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

/** 
# Route Table ( Private )
*/
resource "aws_route_table" "private_1a" {
  count  = var.enable_private ? 1 : 0
  vpc_id = aws_vpc.common.id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-private-rt-1a${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_route_table" "private_1c" {
  count  = var.enable_private ? 1 : 0
  vpc_id = aws_vpc.common.id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-private-rt-1c${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_route_table" "private_1d" {
  count  = var.enable_private ? 1 : 0
  vpc_id = aws_vpc.common.id

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-private-rt-1d${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_route_table_association" "private_1a" {
  count          = var.enable_private ? 1 : 0
  subnet_id      = aws_subnet.private_1a[0].id
  route_table_id = aws_route_table.private_1a[0].id
}

resource "aws_route_table_association" "private_1c" {
  count          = var.enable_private ? 1 : 0
  subnet_id      = aws_subnet.private_1c[0].id
  route_table_id = aws_route_table.private_1c[0].id
}

resource "aws_route_table_association" "private_1d" {
  count          = var.enable_private ? 1 : 0
  subnet_id      = aws_subnet.private_1d[0].id
  route_table_id = aws_route_table.private_1d[0].id
}

resource "aws_route" "private_1a" {
  count                  = var.enable_private ? 1 : 0
  route_table_id         = aws_route_table.private_1a[0].id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1a[0].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1c" {
  count                  = var.enable_private ? 1 : 0
  route_table_id         = aws_route_table.private_1c[0].id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1c[0].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1d" {
  count                  = var.enable_private ? 1 : 0
  route_table_id         = aws_route_table.private_1d[0].id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1d[0].id
  destination_cidr_block = "0.0.0.0/0"
}