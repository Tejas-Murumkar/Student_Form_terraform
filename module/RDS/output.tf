output "db_endpoint" {
  description = "db endpoint of database"
  value = aws_db_instance.rds.endpoint
}
