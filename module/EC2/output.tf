output "instance_public_ip" {
  description = "public IP address of public instance"
  value = aws_instance.instace.public_ip
}
output "instace_private_ip" {
  description = "private IP address of private instance"
  value = aws_instance.private-1.private_ip
}

output "security_group_id" {
  value = aws_security_group.ssh.id
}