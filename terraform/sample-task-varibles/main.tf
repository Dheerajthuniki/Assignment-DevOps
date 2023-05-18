terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}

provider "aws" {
    region = var.region
    profile = var.awskey
    
}

resource "aws_vpc" "my_vpc" {
 
  cidr_block = var.my_vpc_cidr
   tags = {
    Name = var.my_vpc_tag
    }
}
    
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet1_cidr
  availability_zone = var.public_subnet1_az
  tags = {
    Name = var.public_subnet1_tag
  }
} 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
   tags = {
      Name = "my_route_table"
   }
}
resource "aws_route_table_association" "route_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "sg_public" {

  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "ssh connection"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 ingress {
    description      = "nodejs connection"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "teraform_sg"
  }
}
resource "aws_instance" "prb_instance" {
  ami           = var.ami_instance
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  key_name = var.key_pair
  #security_groups_id = aws_security_group.sg_public.id
  associate_public_ip_address = true
  tags = {
    Name = var.instance_name
  }
}