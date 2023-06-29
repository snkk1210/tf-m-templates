resource "aws_vpc" "common" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_support   = var.vpc.enable_dns_support
  enable_dns_hostnames = var.vpc.enable_dns_hostnames

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-vpc"
    Environment = var.common.environment
  }
}