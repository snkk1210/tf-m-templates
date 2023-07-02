/**
# Private Sunbet
*/
resource "aws_eip" "eip_nat_gateway_1a" {
  count      = var.enable_private ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.common.project}-${var.common.environment}-natgw-eip-1a"
  }
}

resource "aws_eip" "eip_nat_gateway_1c" {
  count      = var.enable_private ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.common.project}-${var.common.environment}-natgw-eip-1c"
  }
}

resource "aws_eip" "eip_nat_gateway_1d" {
  count      = var.enable_private ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.common.project}-${var.common.environment}-natgw-eip-1d"
  }
}

resource "aws_nat_gateway" "nat_gateway_1a" {
  count         = var.enable_private ? 1 : 0
  allocation_id = aws_eip.eip_nat_gateway_1a.id
  subnet_id     = aws_subnet.public_1a.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.common.project}-${var.common.environment}-natgw-1a"
  }
}

resource "aws_nat_gateway" "nat_gateway_1c" {
  count         = var.enable_private ? 1 : 0
  allocation_id = aws_eip.eip_nat_gateway_1c.id
  subnet_id     = aws_subnet.public_1c.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.common.project}-${var.common.environment}-natgw-1c"
  }
}

resource "aws_nat_gateway" "nat_gateway_1d" {
  count         = var.enable_private ? 1 : 0
  allocation_id = aws_eip.eip_nat_gateway_1d.id
  subnet_id     = aws_subnet.public_1d.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.common.project}-${var.common.environment}-natgw-1d"
  }
}

resource "aws_subnet" "private_1a" {
  count                   = var.enable_private ? 1 : 0
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.12.0/22"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.common.project}-${var.common.environment}-private-subnet-1a"
  }
}

resource "aws_subnet" "private_1c" {
  count                   = var.enable_private ? 1 : 0
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.16.0/22"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.common.project}-${var.common.environment}-private-subnet-1c"
  }
}

resource "aws_subnet" "private_1d" {
  count                   = var.enable_private ? 1 : 0
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.20.0/22"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.common.project}-${var.common.environment}-private-subnet-1d"
  }
}

resource "aws_route_table" "private_1a" {
  count  = var.enable_private ? 1 : 0
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.common.project}-${var.common.environment}-private-rt-1a"
  }
}

resource "aws_route_table" "private_1c" {
  count  = var.enable_private ? 1 : 0
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.common.project}-${var.common.environment}-private-rt-1c"
  }
}

resource "aws_route_table" "private_1d" {
  count  = var.enable_private ? 1 : 0
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.common.project}-${var.common.environment}-private-rt-1d"
  }
}

resource "aws_route_table_association" "private_1a" {
  count          = var.enable_private ? 1 : 0
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table_association" "private_1c" {
  count          = var.enable_private ? 1 : 0
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_1c.id
}

resource "aws_route_table_association" "private_1d" {
  count          = var.enable_private ? 1 : 0
  subnet_id      = aws_subnet.private_1d.id
  route_table_id = aws_route_table.private_1d.id
}

resource "aws_route" "private_1a" {
  count                  = var.enable_private ? 1 : 0
  route_table_id         = aws_route_table.private_1a.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1a.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1c" {
  count                  = var.enable_private ? 1 : 0
  route_table_id         = aws_route_table.private_1c.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1c.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1d" {
  count                  = var.enable_private ? 1 : 0
  route_table_id         = aws_route_table.private_1d.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1d.id
  destination_cidr_block = "0.0.0.0/0"
}