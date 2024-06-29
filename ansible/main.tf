resource "aws_security_group" "sg" {
  name = "aws_security_group"
  description = "AWS Security Group"
  vpc_id = "vpc-06a2347f2744e4c45"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    to_port = 0
  }
}

output "sg-id" {
  value = aws_security_group.sg.id
}

resource "aws_instance" "first" {
  ami = "ami-01b799c439fd5516a"
  instance_type = "t2.micro"
  key_name = "nat"
  subnet_id = "subnet-02a373f20e12606fa"
  security_groups = [ aws_security_group.sg.id ]
  user_data = <<-EOF
  #!/bin/bash
  echo "            " >> /home/ec2-user/.ssh/authorized_keys
  echo "<Enter your public here>" >> /home/ec2-user/.ssh/authorized_keys
  EOF
    tags = {
        Name = "first"
    }
}

output "public" {
  value = aws_instance.first.public_ip
}
