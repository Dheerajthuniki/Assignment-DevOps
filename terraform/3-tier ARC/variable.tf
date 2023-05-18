variable "region" {
  type = string
  default = "ap-south-1"
}
variable "my_vpc_cidr" {
    type = string 
    default = "10.0.0.0/24"
}
variable "my_vpc_tag" {
    type = string 
    default = "my_assmt_vpc"
  
}
variable "public_subnet1_cidr" {
    type = string 
    default = "10.0.0.0/28"
}
variable "public_subnet1_az" {
    type = string 
    default = "ap-south-1a"
}
variable "public_subnet1_tag" {
    type = string
    default = "public_subnet_task1"
  
}
variable "public_subnet2_cidr" {
    type = string 
    default = "10.0.0.16/28"
}
variable "public_subnet2_az" {
    type = string 
    default = "ap-south-1b"
}
variable "public_subnet2_tag" {
    type = string
    default = "public_subnet_task2"
  
}
variable "private_subnet1_cidr" {
    type = string
    default = "10.0.0.32/28"
  
}
variable "private_subnet1_az" {
    type = string
    default = "ap-south-1a"
  
}
variable "private_subnet1_tag" {
    type = string
    default = "private_subnet_task1"
  
}
variable "private_subnet2_cidr" {
    type = string
    default = "10.0.0.48/28"
  
}
variable "private_subnet2_az" {
    type = string
    default = "ap-south-1b"
  
}
variable "private_subnet2_tag" {
    type = string
    default = "private_subnet_task2"
  
}
variable "private_subnet1_db_cidr" {
    type = string
    default = "10.0.0.64/28"
  
}
variable "private_subnet1_db_az" {
    type = string
    default = "ap-south-1a"
  
}
variable "private_subnet1_db_tag" {
    type = string
    default = "private_subnet_db1"
  
}
variable "private_subnet2_db_cidr" {
    type = string
    default = "10.0.0.80/28"
  
}
variable "private_subnet2_db_az" {
    type = string
    default = "ap-south-1b"
  
}
variable "private_subnet2_db_tag" {
    type = string
    default = "private_subnet_db2"
  
}