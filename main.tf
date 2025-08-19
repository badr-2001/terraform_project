## VPC and Subnets -------------------
module "vpc" {
  source = "./modules/vpc"
  create_vpc = false
  existing_vpc_id = var.vpc_id
}

module "bei_public_subnet_1" {
  source = "./modules/subnet"
  vpc_id = module.vpc.id
  cidr_block = var.public_subnet1_cidr
  availability_zone = var.public_subnet_az1
  subnet_name=var.public_subnet_name1
  map_public_ip_on_launch = true
}

module "bei_private_subnet_1" {
  source = "./modules/subnet"
  vpc_id = module.vpc.id
  cidr_block = var.private_subnet1_cidr
  availability_zone = var.private_subnet_az1
  subnet_name=var.private_subnet_name1
}
module "bei_public_subnet_2" {
  source = "./modules/subnet"
  vpc_id = module.vpc.id
  cidr_block = var.public_subnet2_cidr
  availability_zone = var.public_subnet_az2
  subnet_name=var.public_subnet_name2
  map_public_ip_on_launch = true
}

module "bei_private_subnet_2" {
  source = "./modules/subnet"
  vpc_id = module.vpc.id
  cidr_block = var.private_subnet2_cidr
  availability_zone = var.private_subnet_az2
  subnet_name=var.private_subnet_name2
}


module "bei_ec2_private_1" {
  source = "./modules/ec2"
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = module.bei_private_subnet_1.id
  associate_public_ip_address = false
  sg_ids = [module.back_sg.id]
  key_name = module.key_pair.key_name
  user_data = <<-EOF
#!/bin/bash
set -eux
apt-get update -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx
echo "OK from $(hostname)" > /var/www/html/index.html
EOF
  user_data_replace_on_change = true
  tag_name = var.ec2_name_private1
}

module "bei_ec2_private_2" {
  source = "./modules/ec2"
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = module.bei_private_subnet_2.id
  associate_public_ip_address = false
  sg_ids = [module.back_sg.id]
  key_name = module.key_pair.key_name
  user_data = <<-EOF
#!/bin/bash
set -eux
apt-get update -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx
echo "OK from $(hostname)" > /var/www/html/index.html
EOF
  user_data_replace_on_change = true
  tag_name = var.ec2_name_private2
}

module "back_sg" {
  source         = "./modules/sg"
  vpc_id         = module.vpc.id
  sg_name        = var.sg_name
  sg_description = var.sg_desc

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
  key_name   = var.kp_name
  public_key = file(var.public_key_path)
}

# --- NAT EIP + NAT Gateway in the public subnet ---
module "nat_eip" {
  source = "./modules/eip"
  name   = var.nat_eip_name
}

module "nat" {
  source        = "./modules/nat"
  allocation_id = module.nat_eip.allocation_id
  subnet_id     = module.bei_public_subnet_1.id
  name          = var.nat_name
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
  igw_name        = var.igw_name
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

##Loadbalancer
module "alb" {
  source      = "./modules/alb"
  vpc_id      = module.vpc.id
  name        = "bei-lb"
  subnet_ids  = [module.bei_public_subnet_1.id, module.bei_public_subnet_2.id]
  target_port = 80
  target_ids  = [module.bei_ec2_private_1.id, module.bei_ec2_private_2.id] 
}

##Allow ALB to reach backend on port 80
resource "aws_security_group_rule" "allow_alb_to_back_80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.back_sg.id         
  source_security_group_id = module.alb.sg_id           
}


output "alb_dns" { value = module.alb.dns_name }






 