variable "vpc_cidr_block" {
  type = string
  description = "cidr of VPC"
}

variable "subnet_cidr" {
  type = list(string)
  description = "cidr of subnet"
}
variable "map_public_ip_on_launch" {
  type = list(bool)
  description = "boolean value of map_public_ip_on_launch"
}
variable "availability_zone" {
  type = list(string)
  description = "availability zone of subnet"
}

variable "private_ip" {
  type = list(string)
  description = "private ip for public network interfaces"
}
variable "sg-ports" {
  type = list(number)
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

variable "db_specification" {
  type = map(string)
  description = "name of the database"
}

variable "db_allocated_storage" {
  type = number
  description = "allocated storage for the database"
}