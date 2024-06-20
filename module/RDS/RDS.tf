
#Create DB subnet group for private subnets
resource "aws_db_subnet_group" "db-subnet" {
  name = "db-subnet"
  subnet_ids = [var.subnet_id_tomcat,var.subnet_id_database]
}

#Create DB instance 
resource "aws_db_instance" "rds" {
  allocated_storage = var.db_allocated_storage
  db_name = var.name
  engine = var.engine
  engine_version = var.engine_version
  username = var.username
  password = var.password
  instance_class = var.instance_class
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name

  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "Student1"
  }
}
