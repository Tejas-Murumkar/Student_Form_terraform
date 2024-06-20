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