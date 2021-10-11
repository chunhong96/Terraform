terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

// VPC 

resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "prod-vpc1"
    }
}

// Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-igw"
  }
}

// Route Table

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
      carrier_gateway_id = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id = ""
      instance_id = ""
      ipv6_cidr_block = ""
      local_gateway_id = ""
      nat_gateway_id = ""
      network_interface_id = ""
      transit_gateway_id = ""
      vpc_endpoint_id = ""
      vpc_peering_connection_id = ""
    }
  ]

  tags = {
    Name = "prod-rt"
  }
}

// Subnet

resource "aws_subnet" "prod-subnet" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    name = "prod-subnet1"
  }
}

// Associate subnet with Route Table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.prod-subnet.id
  route_table_id = aws_route_table.prod-route-table.id
}

// Security Group

resource "aws_security_group" "allow_webtraffic" {
  name        = "allow_web"
  description = "Allow Web traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress = [
    {
      description      = "HTTPS from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false     
    }
    ,
    {
      description      = "HTTP from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false  
    }
    ,
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false  
    }
  ]

  egress = [
    {
      description      = "allow-outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"         //means any protocol
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = false  
    }
  ]

  tags = {
    Name = "allow_web"
  }
}

// Network Interface

resource "aws_network_interface" "prod-nic" {
  subnet_id       = aws_subnet.prod-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_webtraffic.id]

}

// Elastic IP

resource "aws_eip" "prod-ip" {
  vpc                       = true
  network_interface         = aws_network_interface.prod-nic.id
  associate_with_private_ip = "10.0.1.50"

  depends_on = ["aws_internet_gateway.gw"]
}

//Create Ubuntu Server EC2

resource "aws_instance" "prod-webserver" {
  ami = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "main-key"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.prod-nic.id

  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your very first web server > /var/www/html/index.html'
              EOF
  tags = {
    Name = "web-server"
  }           
}