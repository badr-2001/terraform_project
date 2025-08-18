module "vpc" {
  source = "./modules/vpc"
  create_vpc = false
  existing_vpc_id = var.vpc_id
}

module "bei_public_subnet_1" {
  source = "./modules/subnet"
  vpc_id = module.vpc.id
  cidr_block = "172.31.10.0/28"
  availability_zone = "us-west-2a"
  subnet_name="bei_public_subnet_1"
  map_public_ip_on_launch = true
}

module "bei_private_subnet_1" {
  source = "./modules/subnet"
  vpc_id = module.vpc.id
  cidr_block = "172.31.10.32/28"
  availability_zone = "us-west-2a"
  subnet_name="bei_private_subnet_1"
}

  