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
    access_key =
    secret_key = 
}

resource "aws_vpc" "my_vpc" {
 
  cidr_block = var.my_vpc_cidr
   tags = {
    Name = var.my_vpc_tag
    }
}
    
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet1_cidr
  availability_zone = var.public_subnet1_az
  tags = {
    Name = var.public_subnet1_tag
  }
} 

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet2_cidr
   availability_zone = var.public_subnet2_az
  tags = {
    Name = var.public_subnet2_tag
  }
} 
resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet1_cidr
   availability_zone = var.private_subnet1_az
  tags = {
    Name = var.private_subnet1_tag
  }
} 
resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet2_cidr
   availability_zone = var.private_subnet2_az
  tags = {
    Name = var.private_subnet2_tag
  }
} 
resource "aws_subnet" "private_subnet_db1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet1_db_cidr
   availability_zone = var.private_subnet1_db_az
  tags = {
    Name = var.private_subnet1_db_tag
  }
} 
resource "aws_subnet" "private_subnet_db2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet2_db_cidr
   availability_zone = var.private_subnet2_db_az
  tags = {
    Name = var.private_subnet2_db_tag
  }
} 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw_task"
  }
}

resource "aws_eip" "eip_task1" {
  vpc = true
}
resource "aws_nat_gateway" "nat_task1" {
 allocation_id = aws_eip.eip_task1.id 
  subnet_id     = aws_subnet.public_subnet1.id
  connectivity_type = "public"
  tags = {
    Name = "NAT_gateway_task1"
  }
}
resource "aws_eip" "eip_task2" {
  vpc = true
}
resource "aws_nat_gateway" "nat_task2" {
 allocation_id = aws_eip.eip_task2.id 
  subnet_id     = aws_subnet.public_subnet2.id
  connectivity_type = "public"
  tags = {
    Name = "NAT_gateway_task2"
  }
}
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
   tags = {
      Name = "my_route_table_public"
   }
}
resource "aws_route_table_association" "route_association_public1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.route_table_public.id
}
resource "aws_route_table_association" "route_association_public2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.route_table_public.id
}
resource "aws_route_table" "route_table_private1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_task1.id
  }
   tags = {
      Name = "my_route_table_private1"
   }
}
resource "aws_route_table_association" "route_association_private1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.route_table_private1.id
}
resource "aws_route_table_association" "route_association_private_db1" {
  subnet_id      = aws_subnet.private_subnet_db1.id
  route_table_id = aws_route_table.route_table_private1.id
}

resource "aws_route_table" "route_table_private2" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_task2.id
  }
   tags = {
      Name = "my_route_table_private2"
   }
}
resource "aws_route_table_association" "route_association_private2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.route_table_private2.id
}
resource "aws_route_table_association" "route_association_private_db2" {
  subnet_id      = aws_subnet.private_subnet_db2.id
  route_table_id = aws_route_table.route_table_private2.id
}
