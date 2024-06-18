variable "vpc_cidr_block" {
  type = string
  description = "cidr of VPC"
}

variable "public_subnet_cidr" {
  type = string
  description = "cidr of public subnet"
}

variable "availability_zone_public" {
  type = string
  description = "availability zone of public subnet"
}

variable "tomcat_subnet_cidr" {
  type = string
  description = "cidr of tomcat subnet"
}

variable "availability_zone_tomcat" {
  type = string
  description = "availability zone for tomcat subnet"
}

variable "database_subnet_cidr" {
  type = string
  description = "cidr of database subnet"
}

variable "availability_zone_darabases" {
  type = string
  description = "availability zone for databases subnet"
}

variable "private_ip_public" {
  type = string
  description = "private ip for public network interfaces"
}

variable "private_ip_tomcat" {
  type = string
  description = "private ip for tomcat network interfaces"
}

variable "private_ip_database" {
  type = string
  description = "private ip for database network interfaces"
}

variable "ami_id" {
  type = string
  description = "ami id "

}

variable "instance_type" {
  type = string
  description = "instance type"
}

variable "key_name" {
  type = string
  description = "key name"

}

variable "db_name" {
  type = string
  description = "name of the database"
}

variable "db_username" {
  type = string
  description = "name of the database user"
}

variable "db_password" {
  type = string
  description = "password of the database user"
}

variable "db_instance_class" {
  type = string
  description = "instance class of the database"
}

variable "db_engine" {
  type = string
  description = "database engine"
}

variable "db_engine_version" {
  type = string
  description = "database engine version"
}

variable "allocated_storage" {
  type = number
  description = "allocated storage for the database"
}