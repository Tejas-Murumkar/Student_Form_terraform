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


