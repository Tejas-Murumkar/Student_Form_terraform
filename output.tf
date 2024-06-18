output "instance_public_ip" {
  description = "public IP address of public instance"
  value = aws_instance.instace.public_ip
}

output "db_endpoint" {
  description = "db endpoint of database"
  value = aws_db_instance.rds.endpoint
}

output "instace_private_ip" {
  description = "private IP address of private instance"
  value = aws_instance.private-1.private_ip
}