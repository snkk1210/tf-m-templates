output "vpc_id" {
  value = aws_vpc.common.id
}

output "public_subnet_ids" {
  value = tolist([aws_subnet.public_1a.id, aws_subnet.public_1c.id, aws_subnet.public_1d.id])
}

output "private_subnet_ids" {
  value = tolist([aws_subnet.private_1a.id, aws_subnet.private_1c.id, aws_subnet.private_1d.id])
}

output "isolated_subnet_ids" {
  value = tolist([aws_subnet.isolated_1a.id, aws_subnet.isolated_1c.id, aws_subnet.isolated_1d.id])
}