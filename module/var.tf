variable "vpc_cidr_block" {
  type = string
  description = "cidr of VPC"
}

variable "subnet_cidr" {
  type = string
  description = "cidr of subnet"
}

variable "private_subnet_1_cidr" {
  type = string
  description = "cidr of subnet"
}

variable "private_subnet_2_cidr" {
  type = string
  description = "cidr of subnet"
}

variable "map_public_ip_on_launch" {
  type = bool
  description = "boolean value of map_public_ip_on_launch"
}

variable "map_public_ip_on_launch_private" {
  type = bool
  description = "boolean value of map_public_ip_on_launch"
}

variable "availability_zone" {
  type = string
  description = "availability zone of subnet"
}

variable "private_1_availability_zone" {
  type = string
  description = "availability zone of subnet"
}

variable "private_2_availability_zone" {
  type = string
  description = "availability zone of subnet"
}
variable "private_ip_public" {
  type = string
  description = "private ip for public network interfaces"
}
variable "private_ip_tomcat" {
  type = string
  description = "private ip for public network interfaces"
}
variable "private_ip_database" {
  type = string
  description = "private ip for public network interfaces"
}

variable "ssh" {
  type = number
  description = "Ports for security group"
}
variable "http" {
  type = number
  description = "Ports for security group"
}
variable "https" {
  type = number
  description = "Ports for security group"
}
variable "tomcat" {
  type = number
  description = "Ports for security group"
}
variable "mariadb" {
  type = number
  description = "Ports for security group"
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

