## EC2 Instances ---------------------------------------
resource "aws_instance" "bei_front_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.bei_public_subnet.id

  tags = {
    Name = "bei_front_instance"
  }
}

resource "aws_instance" "bei_back_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.bei_private_subnet.id

  tags = {
    Name = "bei_back_instance"
  }
}

## VPC -----------------------------------------
data "aws_vpc" "main_vpc" {
   id = var.vpc_id
}

## Subnets -----------------------------
resource "aws_subnet" "bei_public_subnet" {
  vpc_id                  = data.aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr

  tags = {
    Name = "bei_public-subnet"
  }
}

resource "aws_subnet" "bei_private_subnet" {
  vpc_id                  = data.aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_cidr

  tags = {
    Name = "bei_private-subnet"
  }
}

## Internet Gateway -----------------------------
data "aws_internet_gateway" "igw" {
  internet_gateway_id = var.igw_id
}