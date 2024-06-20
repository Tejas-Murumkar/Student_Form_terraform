# Creaet a security group 
resource "aws_security_group" "ssh" {
  name = "Three-tier"
  description = "Allow SSH,mysql,tomcat access,http"
  vpc_id = var.vpc_id
}

#Add ports 22,8080,80,3306
resource "aws_vpc_security_group_ingress_rule" "ssh1" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.ssh
  ip_protocol = "tcp"
  to_port = var.ssh
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.https
  ip_protocol = "tcp"
  to_port = var.https
}

resource "aws_vpc_security_group_ingress_rule" "tomcat" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.tomcat
  ip_protocol = "tcp"
  to_port =  var.tomcat
}

resource "aws_vpc_security_group_ingress_rule" "nginx" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.http
  ip_protocol = "tcp"
  to_port =  var.http
}

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port =  var.mariadb
  ip_protocol = "tcp"
  to_port =  var.mariadb
  
}
#Add outbound rule 
resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

#Create Network interface with public subnet to connect instance with VPC
resource "aws_network_interface" "network" {
  subnet_id = var.subnet_id_public
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
    Name = "NGIX"
  }

}

#Create network interface with private subnet to connect instance with VPC
resource "aws_network_interface" "private-network" {
  subnet_id = var.subnet_id_tomcat
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
  subnet_id = var.subnet_id_database
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
