provider "aws" {
  # Configuration options
    region = "us-east-1"
}


variable "subnet_prefix" {
  
}


# Creating a vpc
resource "aws_vpc" "web-server-vpc" {
  cidr_block       = "10.0.0.0/16"
    tags = {
    Name = "web-server"
  }
}

#Creating an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.web-server-vpc.id
  tags = {
    Name = "webserver-gw"
  }
}

#Creating a default route
resource "aws_route_table" "web-server-route-table" {
  vpc_id = aws_vpc.web-server-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "web-server-route-table"
  }
}

#Creating a subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.web-server-vpc.id
  cidr_block = var.subnet_prefix 
  availability_zone = "us-east-1a"

  tags = {
    Name = "Web-server-subnet"
  }
}

#Associating subnet with route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.web-server-route-table.id
}

# Creating a Network Security Group

resource "aws_security_group" "allow_web_traffic" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.web-server-vpc.id

  tags = {
    Name = "allow_web_traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_web_traffic_ipv4" {
  security_group_id = aws_security_group.allow_web_traffic.id
  description = "HTTPS"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_web_traffics_ipv4" {
  security_group_id = aws_security_group.allow_web_traffic.id
  description = "HTTP"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_web_trafficss_ipv4" {
  security_group_id = aws_security_group.allow_web_traffic.id
  description = "SSH"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_web_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Creating a NIC with an ip in the subnet we created

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web_traffic.id]

}

# Assign a public Ip address to the NIC

resource "aws_eip" "web-server-eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [ aws_internet_gateway.gw , aws_instance.web-server-instance ]   ############### elactic ip depends on internet gateway to work hence this line ########### 
}

# Create Ubuntr Server and install/enable Apache2

resource "aws_instance" "web-server-instance" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro" 
  availability_zone = "us-east-1a" 
  key_name = "main-key"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  } 

  user_data = <<-EOF
               #!/bin/bash
               sudo apt update -y
               sudo apt install apache2 -y
               sudo systemctl start apache2
               sudo bash -c 'echo your very first web server > /var/www/html/index.html' 
               EOF
  tags = {
    Name = "Web Server"
  }

}
