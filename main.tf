## EC2 Instances ---------------------------------------
resource "aws_instance" "bei_front_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.bei_public_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.front_sg.id]
  user_data_replace_on_change = true

  user_data = <<EOF
#!/bin/bash
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y ca-certificates curl gnupg
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs build-essential
npm install -g @angular/cli http-server
echo 'export badr1=5' >> /home/ubuntu/.bashrc


EOF

  tags = { Name = "bei_front_instance" }
}


resource "aws_instance" "bei_back_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.bei_private_subnet.id

  user_data = <<-EOF
              sudo yum update -y
              sudo yum install -y python3 python3-pip
              EOF

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
## Route Tables -----------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.bei_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.main_vpc.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.bei_private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

## Security Groups ---------------------------------
resource "aws_security_group" "front_sg" {
  name        = "front-instance-sg"
  description = "Security group for front instance"
  vpc_id      = data.aws_vpc.main_vpc.id

  ingress {
    description = "SSH from any IP (testing purposes)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "front_sg"
  }
}