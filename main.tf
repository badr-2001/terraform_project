module "vpc" {
  source          = "./modules/vpc"
  create_vpc      = false
  existing_vpc_id = var.vpc_id
}

# --- Internet Gateway ---
module "igw" {
  source          = "./modules/igw"
  create_igw      = false
  existing_igw_id = var.igw_id
  vpc_id          = module.vpc.id
  igw_name        = var.igw_name
}

# --- Subnets ---
module "public_subnet" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.id
  cidr_block        = var.public_subnet_cidr
  subnet_name       = var.public_subnet_name
  availability_zone = var.public_az
}

module "private_subnet" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.id
  cidr_block        = var.private_subnet_cidr
  subnet_name       = var.private_subnet_name
  availability_zone = var.private_az
}

# --- Public Route Table +  route to IGW ---
module "public_rt" {
  source = "./modules/route_table"
  vpc_id = module.vpc.id
  name   = var.rt_name
  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      gateway_id     = module.igw.id
      nat_gateway_id = null
    }
  ]
}

module "public_assoc" {
  source         = "./modules/rt_association"
  subnet_id      = module.public_subnet.id
  route_table_id = module.public_rt.id
}

# --- NAT EIP + NAT Gateway in the public subnet ---
module "nat_eip" {
  source = "./modules/eip"
  name   = var.nat_eip_name
}

module "nat" {
  source        = "./modules/nat"
  allocation_id = module.nat_eip.allocation_id
  subnet_id     = module.public_subnet.id
  name          = var.nat_name
}

# --- Private Route Table + route to NAT ---
module "private_rt" {
  source = "./modules/route_table"
  vpc_id = module.vpc.id
  name   = "private-route-table"
  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      gateway_id     = null
      nat_gateway_id = module.nat.id
    }
  ]
}

module "private_assoc" {
  source         = "./modules/rt_association"
  subnet_id      = module.private_subnet.id
  route_table_id = module.private_rt.id
}

# --- Security Groups ---
module "front_sg" {
  source         = "./modules/sg"
  vpc_id         = module.vpc.id
  sg_name        = "front-instance-sg"
  sg_description = "Security group for front instance"

  ingress_rules = [
    {
      description = "SSH from any IP (testing purposes)"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] ## in real world senarios , we give only the list of trusted ips
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] ## in real world senarios , we give only the list of trusted ips , and allow only needed ports and protocols
    }
  ]
}

module "back_sg" {
  source         = "./modules/sg"
  vpc_id         = module.vpc.id
  sg_name        = "back-instance-sg"
  sg_description = "Security group for back instance"

  ingress_rules = [
    {
      description = "SSH from any IP (testing purposes)"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] ## in real world senarios , we give only the list of trusted ips
    }
  ]

  egress_rules = [
    {
      from_port   = 0 #and allow only needed ports and protocols
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] 
    }
  ]
}

# --- SSH Key Pair ---
module "key_pair" {
  source     = "./modules/key_pair"
  key_name   = var.kp_name
  public_key = file(var.public_key_path)
}

# --- EC2 ---
module "bei_front_instance" {
  source                      = "./modules/ec2"
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.public_subnet.id
  associate_public_ip_address = true
  sg_ids                      = [module.front_sg.id]
  key_name                    = module.key_pair.key_name
  tag_name                    = var.ec2_name_front
  user_data_replace_on_change = true

  user_data = <<-EOF
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
}

# --- EC2: Back (private) ---
module "bei_back_instance" {
  source                      = "./modules/ec2"
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.private_subnet.id
  associate_public_ip_address = false
  sg_ids                      = [module.back_sg.id]
  key_name                    = module.key_pair.key_name
  tag_name                    = var.ec2_name_back
  user_data_replace_on_change = true

  user_data = <<-EOF
    #cloud-config
    package_update: true
    packages:
      - python3
      - python3-pip
      - python-is-python3
  EOF
}