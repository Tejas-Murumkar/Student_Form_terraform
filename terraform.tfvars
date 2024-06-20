vpc_cidr_block = "10.0.0.0/16"
subnet_cidr = ["10.0.1.0/24","10.0.20.0/25","10.0.30.0/26"]
availability_zone = ["us-east-1a","us-east-1b","us-east-1c"]
map_public_ip_on_launch = [ true, false]
private_ip= ["10.0.1.100","10.0.20.100","10.0.30.100"]
sg-ports = [ 22,443,8080,80,3306,0 ]
ami_id = "ami-08a0d1e16fc3f61ea"
instance_type = "t2.micro"
key_name = "nat"
db_specification = {
name = "student"
engine = "MariaDB"
engine_version = "10.11.6"
instance_class = "db.t3.micro"
username = "admin"
password = "passwd123"
}

db_allocated_storage = 20