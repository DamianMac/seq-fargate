
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = [aws_subnet.main.id, aws_subnet.secondary.id]
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block
}
