module "vpc" {
  source = "./modules/vpc"
  create_vpc = false
  existing_vpc_id = var.vpc_id
}

module "bei_public_subnet_1" {
  source = "./modules/subnet"
  vpc_id = module.vpc.id
  cidr_block = "172.31.10.0/28"
  availability_zone = "eu-west-1a"
  subnet_name="bei_public_subnet_1"
  map_public_ip_on_launch = true
}

module "bei_private_subnet_1" {
  source = "./modules/subnet"
  vpc_id = module.vpc.id
  cidr_block = "172.31.10.32/28"
  availability_zone = "eu-west-1a"
  subnet_name="bei_private_subnet_1"
}
module "bei_public_subnet_2" {
  source = "./modules/subnet"
  vpc_id = module.vpc.id
  cidr_block = "172.31.10.16/28"
  availability_zone = "eu-west-1b"
  subnet_name="bei_public_subnet_2"
  map_public_ip_on_launch = true
}

module "bei_private_subnet_2" {
  source = "./modules/subnet"
  vpc_id = module.vpc.id
  cidr_block = "172.31.10.48/28"
  availability_zone = "eu-west-1b"
  subnet_name="bei_private_subnet_2"
}


module "bei_ec2_private_1" {
  source = "./modules/ec2"
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = module.bei_public_subnet_1.id
  associate_public_ip_address = false
  sg_ids = [module.back_sg.id]
  key_name = module.key_pair.key_name
  user_data = null
  user_data_replace_on_change = true
  tag_name = "bei2_ec2_private_1"
}

module "bei_ec2_private_2" {
  source = "./modules/ec2"
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = module.bei_public_subnet_2.id
  associate_public_ip_address = false
  sg_ids = [module.back_sg.id]
  key_name = module.key_pair.key_name
  user_data = null
  user_data_replace_on_change = true
  tag_name = "bei2_ec2_private_2"
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
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}


module "key_pair" {
  source     = "./modules/key_pair"
  key_name   = "terraform-key"
  public_key = file(var.public_key_path)
}

# --- NAT EIP + NAT Gateway in the public subnet ---
module "nat_eip" {
  source = "./modules/eip"
  name   = "nat-eip"
}

module "nat" {
  source        = "./modules/nat"
  allocation_id = module.nat_eip.allocation_id
  subnet_id     = module.bei_public_subnet_1.id
  name          = "main-nat"
}

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

module "private_assoc1" {
  source         = "./modules/rt_association"
  subnet_id      = module.bei_private_subnet_1.id
  route_table_id = module.private_rt.id
}

module "private_assoc2" {
  source         = "./modules/rt_association"
  subnet_id      = module.bei_private_subnet_2.id
  route_table_id = module.private_rt.id
}



##make public subnet 

module "igw" {
  source          = "./modules/igw"
  create_igw      = false
  existing_igw_id = var.igw_id
  vpc_id          = module.vpc.id
  igw_name        = "main-igw"
}

module "public_rt" {
  source = "./modules/route_table"
  vpc_id = module.vpc.id
  name   = "public-route-table"
  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      gateway_id     = module.igw.id
      nat_gateway_id = null
    }
  ]
}

module "public_assoc1" {
  source         = "./modules/rt_association"
  subnet_id      = module.bei_public_subnet_1.id
  route_table_id = module.public_rt.id
}

module "public_assoc2" {
  source         = "./modules/rt_association"
  subnet_id      = module.bei_public_subnet_2.id
  route_table_id = module.public_rt.id
}







 