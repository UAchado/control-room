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

output "lbs_sg_id" {
  value = aws_security_group.lbs.id
}

output "instances_sg_id" {
  value = aws_security_group.instances.id
}

output "public_instances_sg_id" {
  value = aws_security_group.public_instances.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}