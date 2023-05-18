terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
    profile = "default"
}

resource "aws_vpc" "my_vpc" {

  cidr_block = "10.0.0.0/24"
   tags = {
    Name = "my_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "ap-south-1a"


  tags = {
    Name = "public_subnet"
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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
resource "aws_instance" "terra_instance" {
  ami           =  "ami-0376ec8eacdf70aae"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  key_name = "Demokeypair"
  associate_public_ip_address = true
  tags = {
    Name = "projectweb"
  }
 provisioner "remote-exec" {
    inline = [

    ]
    connection {
      type = "ssh"
      host = "aws_instancre.terra_instance.public_ip"
      user = "ec2-user"
      private_key = file("/home/ec2-user/key.pem")
    }

  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.terra_instance.public_ip}, --private-key ${/home/ec2-user/key.pem} taskmaster.yml"

  }
}
output "aws_instance_ip"{
value = "aws_instancre.terra_instance.public_ip"
}




