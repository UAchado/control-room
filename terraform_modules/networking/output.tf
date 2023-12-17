output "public_subnet_ids" {
    value = [ aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id ]
}

output "private_subnet_ids" {
    value = [ aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id ]
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}