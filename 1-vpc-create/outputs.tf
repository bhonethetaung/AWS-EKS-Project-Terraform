output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnets" {
  value = aws_subnet.private_sub[*].id
}

output "public_subnets" {
  value = aws_subnet.public_sub[*].id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}