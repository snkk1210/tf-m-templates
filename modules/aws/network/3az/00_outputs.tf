/** 
# Outputs
*/
output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = tolist(
    [
      aws_subnet.public_az1.id,
      aws_subnet.public_az2.id,
      aws_subnet.public_az3.id
    ]
  )
}

output "private_subnet_ids" {
  value = tolist(
    [
      aws_subnet.private_az1[*].id,
      aws_subnet.private_az2[*].id,
      aws_subnet.private_az3[*].id
    ]
  )
}

output "isolated_subnet_ids" {
  value = tolist(
    [
      aws_subnet.isolated_az1.id,
      aws_subnet.isolated_az2.id,
      aws_subnet.isolated_az3.id
    ]
  )
}