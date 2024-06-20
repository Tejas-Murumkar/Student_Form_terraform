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
  cidr_block = var.subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch 

  tags = {
    Name = "Public-subnet_1",
  }
}

#Create Private subnet for Tomcat
resource "aws_subnet" "private-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = var.private_1_availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch_private

  tags = {
    Name = "Private-subnet-1"
  }

}

#Create PRivate Subnet for Database
resource "aws_subnet" "private-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = var.private_2_availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch_private

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
