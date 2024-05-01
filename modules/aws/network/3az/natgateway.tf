/** 
# Elastic IP ( Nat Gateway )
*/
resource "aws_eip" "eip_nat_gateway_az1" {
  count      = var.enable_private ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-eip-${substr(var.az1, -2, -2)}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_eip" "eip_nat_gateway_az2" {
  count      = var.enable_private ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-eip-${substr(var.az2, -2, -2)}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_eip" "eip_nat_gateway_az3" {
  count      = var.enable_private ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-eip-${substr(var.az3, -2, -2)}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

/** 
# Nat Gateway
*/
resource "aws_nat_gateway" "nat_gateway_az1" {
  count         = var.enable_private ? 1 : 0
  allocation_id = aws_eip.eip_nat_gateway_az1[0].id
  subnet_id     = aws_subnet.public_az1.id
  depends_on    = [aws_internet_gateway.this]

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-${substr(var.az1, -2, -2)}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_nat_gateway" "nat_gateway_az2" {
  count         = var.enable_private ? 1 : 0
  allocation_id = aws_eip.eip_nat_gateway_az2[0].id
  subnet_id     = aws_subnet.public_az2.id
  depends_on    = [aws_internet_gateway.this]

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-${substr(var.az2, -2, -2)}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_nat_gateway" "nat_gateway_az3" {
  count         = var.enable_private ? 1 : 0
  allocation_id = aws_eip.eip_nat_gateway_az3[0].id
  subnet_id     = aws_subnet.public_az3.id
  depends_on    = [aws_internet_gateway.this]

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-natgw-${substr(var.az3, -2, -2)}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}
