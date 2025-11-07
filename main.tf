terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.12.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "myvpc" {
  cidr_block = "30.30.0.0/16"
}
resource "aws_vpc" "myvpc-1" {
  cidr_block = "30.40.0.0/16"
}
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "30.30.1.0/24"


}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "30.30.2.0/24"

  
  }

resource "aws_internet_gateway" "Ig" {
  vpc_id = aws_vpc.myvpc.id

  
}
resource "aws_route_table" "MRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.Ig.id
}
}
resource "aws_eip" "mynat" {
 
  tags = {
    Name = "my-nat-eip"
  }
}


resource "aws_nat_gateway" "Ng" {
  allocation_id = aws_eip.mynat.id
  subnet_id     = aws_subnet.public.id

}  
resource "aws_route_table" "CRT" {
  vpc_id = aws_vpc.myvpc.id
 route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_nat_gateway.Ng.id
    }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.MRT.id
}


resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.CRT.id
}

