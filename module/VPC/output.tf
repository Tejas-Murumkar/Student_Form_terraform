output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_public_id" {
  value = aws_subnet.public.id
}

output "subnet_tomcat_id" {
  value = aws_subnet.private-1.id
}

output "subnet_database_id" {
  value = aws_subnet.private-2.id
}

