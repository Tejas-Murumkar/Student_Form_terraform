#Create VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block


    tags = {
        Name = "aws_vpc",
    } 
}

#Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone_public
  map_public_ip_on_launch = true 

  tags = {
    Name = "Public-subnet_1",
  }
}

#Create Private subnet for Tomcat
resource "aws_subnet" "private-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.tomcat_subnet_cidr 
  availability_zone = var.availability_zone_tomcat
  map_public_ip_on_launch = false 

  tags = {
    Name = "Private-subnet-1"
  }

}

#Create PRivate Subnet for Database
resource "aws_subnet" "private-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.database_subnet_cidr
  availability_zone = var.availability_zone_darabases
  map_public_ip_on_launch = false 

  tags = {
    Name = "Private-subnet-2"
  }
}

#Create internet gateway 
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = "aws_internet_gateway_1"
    }
  
}

#Create Elastic IP 
resource "aws_eip" "elasticip" {
 domain = "vpc"
}

#Create NAT gateway 
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elasticip.id
  subnet_id = aws_subnet.public.id
}

#Creaet Route table for public subnet
resource "aws_route_table" "RT1" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    
    }
    tags = {
      Name = "Public-RT"
    }
}

#Add public subnet in public route table 
resource "aws_route_table_association" "association" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.RT1.id
}

#Creeate route table for private subnets
resource "aws_route_table" "rt-pri" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
      Name = "Private-RT"
    }
}

#Add private subnets in private route table
resource "aws_route_table_association" "private-association-table" {
  subnet_id = aws_subnet.private-1.id
  route_table_id = aws_route_table.rt-pri.id
}

resource "aws_route_table_association" "private-association-table-2" {
  subnet_id = aws_subnet.private-2.id
  route_table_id = aws_route_table.rt-pri.id
}

# Creaet a security group 
resource "aws_security_group" "ssh" {
  name = "Three-tier"
  description = "Allow SSH,mysql,tomcat access,http"
  vpc_id = aws_vpc.vpc.id
}

#Add ports 22,8080,80,3306
resource "aws_vpc_security_group_ingress_rule" "ssh1" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
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
#Add outbound rule 
resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

#Create Network interface with public subnet to connect instance with VPC
resource "aws_network_interface" "network" {
  subnet_id = aws_subnet.public.id
  private_ip = var.private_ip_public
}

#Attach Security Group to Public Instance
resource "aws_network_interface_sg_attachment" "sg2" {
  security_group_id = aws_security_group.ssh.id
  network_interface_id = aws_instance.instace.primary_network_interface_id
}
#Launch public Instance 
resource "aws_instance" "instace" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  user_data = file("${path.module}/nginx.sh")
  network_interface {
    network_interface_id = aws_network_interface.network.id
    device_index = 0
  }

  tags = {
    Name = "NGIx"
  }

}

#Create network interface with private subnet to connect instance with VPC
resource "aws_network_interface" "private-network" {
  subnet_id = aws_subnet.private-1.id
  private_ip = var.private_ip_tomcat
}

#Launch private instance for tomcat 
resource "aws_instance" "private-1" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
 

  network_interface {
    network_interface_id = aws_network_interface.private-network.id
    device_index = 0
}
  tags = {
    Name = "Private-1-tomcat"
  }
}

#Attach Security Group to Private Instance
resource "aws_network_interface_sg_attachment""sg-private"{
  security_group_id = aws_security_group.ssh.id
  network_interface_id = aws_instance.private-1.primary_network_interface_id
}


#Create network interface with private subnet 2 to connect instance with VPC
resource "aws_network_interface" "private-network-2" {
  subnet_id = aws_subnet.private-2.id
  private_ip = var.private_ip_database
}

#Launch private instance for database
resource "aws_instance" "private-2" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.private-network-2.id
    device_index = 0
  }
  tags = {
    Name = "Database"
  }
  }

  #Attach security group to instance 
  resource "aws_network_interface_sg_attachment" "sg-private-2" {
    security_group_id = aws_security_group.ssh.id
    network_interface_id = aws_instance.private-2.primary_network_interface_id
  }

#Create DB subnet group for private subnets
resource "aws_db_subnet_group" "db-subnet" {
  name = "db-subnet"
  subnet_ids = [aws_subnet.private-1.id,aws_subnet.private-2.id]
}

#Create DB instance 
resource "aws_db_instance" "rds" {
  allocated_storage = var.allocated_storage
  db_name = var.db_name
  engine = var.db_engine
  engine_version = var.db_engine_version
  username = var.db_username
  password = var.db_password
  instance_class = var.db_instance_class
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "Student1"
  }
}



