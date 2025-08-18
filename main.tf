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

module "backend" {
  source      = "./modules/backend"
  bucket_name = "bei2-bucket"
}  