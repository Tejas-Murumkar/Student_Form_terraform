variable "name" {
  type = string
}
variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "db_allocated_storage" {
  type = number
  description = "allocated storage for the database"
}


variable "vpc_id" {
  type = string
}

variable "subnet_id_public" {
  type = string
}

variable "subnet_id_tomcat" {
  type = string
}

variable "subnet_id_database" {
  type = string
}

variable "security_group_id" {
  type = string
}