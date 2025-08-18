## VPC -----------------------------------------
data "aws_vpc" "main_vpc" {
  id = var.vpc_id
}

## Subnets -----------------------------
resource "aws_subnet" "bei_public_subnet" {
  vpc_id     = data.aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "bei_private_subnet" {
  vpc_id     = data.aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = var.private_subnet_name
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
    Name = var.rt_name
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.bei_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

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
    cidr_blocks = ["0.0.0.0/0"] #not a real case , we must specify a range of IPs that we trust 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"           # all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "front_sg" }
}

resource "aws_security_group" "back_sg" {
  name        = "back-instance-sg"
  description = "Security group for back instance"
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

  tags = { Name = "back_sg" }
}

## Nat Gateway setup (for outbound from private) -----------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = { Name = var.nat_eip_name }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.bei_public_subnet.id
  tags          = { Name = var.nat_name }
}

## SSH Key pair -------------------
resource "aws_key_pair" "project_key" { ##Register my SSH public key so I can use it later
  key_name   = var.kp_name
  public_key = file(var.public_key_path)
}

## EC2 Instances ---------------------------------------
resource "aws_instance" "bei_front_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.bei_public_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.front_sg.id]
  key_name                    = aws_key_pair.project_key.key_name
  user_data_replace_on_change = true #If the user_data script changes, destroy and recreate the instance with the new script.

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

  tags = { Name = var.ec2_name_front }
}

resource "aws_instance" "bei_back_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.bei_private_subnet.id
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.back_sg.id]
  key_name               = aws_key_pair.project_key.key_name
  user_data_replace_on_change = true

  user_data = <<-EOF
#cloud-config
package_update: true
packages:
  - python3
  - python3-pip
  - python-is-python3
EOF

  tags = { Name = var.ec2_name_back }
}


output "front_public_ip"  { value = aws_instance.bei_front_instance.public_ip } ##ONLY TESTING PURPOSES
output "back_private_ip"  { value = aws_instance.bei_back_instance.private_ip } ##ONLY TESTING PURPOSES
