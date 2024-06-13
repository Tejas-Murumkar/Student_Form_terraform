provider "aws" {
	region = "us-east-1"
	profile = "Devops_Rushi"
}

#Create A VPC 
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"


    tags = {
        name = "aws_vpc",
    } 
}

#Create a public subnet
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    name = "Public-subnet_1",
  }
}

#Create a private subnet for tomcat 
resource "aws_subnet" "private-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.20.0/25"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false 

  tags = {
    name = "Private-subnet-1"
  }

}
#Create a private subnet for
resource "aws_subnet" "private-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.30.0/26"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = false 

  tags = {
    name = "Private-subnet-2"
  }
}
#Create a internet gateway 
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      name = "aws_internet_gateway_1"
    }
  
}

#Create a elastic ip 
resource "aws_eip" "elasticip" {
 domain = "vpc"
}

#Create a NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elasticip.id
  subnet_id = aws_subnet.public.id
}

#Create a public route table
resource "aws_route_table" "RT1" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    
    }
  
}

#Create a public route table and public subnet association
resource "aws_route_table_association" "association" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.RT1.id
}

#Create a private route table
resource "aws_route_table" "rt-pri" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

#Create a private route table and private subnet association
resource "aws_route_table_association" "private-association-table" {
  subnet_id = aws_subnet.private-1.id
  route_table_id = aws_route_table.rt-pri.id
}

resource "aws_route_table_association" "private-association-table-2" {
  subnet_id = aws_subnet.private-2.id
  route_table_id = aws_route_table.rt-pri.id
}
# Create a Security group  

resource "aws_security_group" "ssh" {
  name = "Three-tier"
  description = "Allow SSH,mysql,tomcat access"
  vpc_id = aws_vpc.vpc.id
}

#Add port 22,80,8080,3306 in inbound rule 
resource "aws_vpc_security_group_ingress_rule" "ssh1" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "tomcat" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 8080
  ip_protocol = "tcp"
  to_port = 8080
}

resource "aws_vpc_security_group_ingress_rule" "nginx" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 3306
  ip_protocol = "tcp"
  to_port = 3306
  
}

#Add outbout rule 
resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

#Add network interface with public subnet to connet to public instance /nginx instance  
resource "aws_network_interface" "network" {
  subnet_id = aws_subnet.public.id
  private_ip = "10.0.1.100/24"
}

#Attach the security group to instance 
resource "aws_network_interface_sg_attachment" "sg2" {
  security_group_id = aws_security_group.ssh.id
  network_interface_id = aws_instance.instace.primary_network_interface_id
}

#Create a instance for NGINX
resource "aws_instance" "instace" {
  ami = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.micro"
  key_name = "nat" 
  network_interface {
    network_interface_id = aws_network_interface.network.id
    device_index = 0
  }

  tags = {
    Name = "NGIx"
  }

}

#Add network interface with private subnet 1 to connet to tomcat instance
resource "aws_network_interface" "private-network" {
  subnet_id = aws_subnet.private-1.id
  private_ip = "10.0.20.100/24"
}
#Create a instance for tomcat
resource "aws_instance" "private-1" {
  ami = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.micro"
  key_name = "nat"
  network_interface {
    network_interface_id = aws_network_interface.private-network.id
    device_index = 0
}
  tags = {
    Name = "Private-1-tomcat"
  }
}

#Attach the security group to instance 
resource "aws_network_interface_sg_attachment""sg-private"{
  security_group_id = aws_security_group.ssh.id
  network_interface_id = aws_instance.private-1.primary_network_interface_id
}

#Add network interface with private subnet to connet to Database instance
resource "aws_network_interface" "private-network-2" {
  subnet_id = aws_subnet.private-2.id
  private_ip = "10.0.30.100"
}

#Create a instance for Database 
resource "aws_instance" "private-2" {
  ami = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.micro"
  key_name = "nat"
  network_interface {
    network_interface_id = aws_network_interface.private-network-2.id
    device_index = 0
  }
  tags = {
    Name = "Database"
  }
  }

#Attach the security group to instance 
  resource "aws_network_interface_sg_attachment" "sg-private-2" {
    security_group_id = aws_security_group.ssh.id
    network_interface_id = aws_instance.private-2.primary_network_interface_id
  }

#Create a subnet group for Database 
resource "aws_db_subnet_group" "db-subnet" {
  name = "db-subnet"
  subnet_ids = [aws_subnet.private-1.id,aws_subnet.private-2.id]
}

# Create a Database with created VPC 
resource "aws_db_instance" "rds" {
  allocated_storage = 20
  db_name = "student"
  engine = "mariadb"
  engine_version = "10.11.6"
  username = "admin"
  password = "passwd123"
  instance_class = "db.t3.micro"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "Student1"
  }
}



