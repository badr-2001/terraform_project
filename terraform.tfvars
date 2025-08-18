##vpc_subnets
vpc_id              = "vpc-0dc6afcbf4b2ee09d"

public_subnet1_cidr  = "172.31.10.0/28"
private_subnet1_cidr = "172.31.10.32/28"
public_subnet2_cidr  = "172.31.10.16/28"
private_subnet2_cidr = "172.31.10.48/28"

public_subnet_az1 = "eu-west-1a"
private_subnet_az1 = "eu-west-1a"
public_subnet_az2 = "eu-west-1b"
private_subnet_az2 = "eu-west-1b"

public_subnet_name1 = "bei_public_subnet_1"
private_subnet_name1 = "bei_private_subnet_1"
public_subnet_name2 = "bei_public_subnet_2"
private_subnet_name2 = "bei_private_subnet_2"


##EC2
ami                 = "ami-01f23391a59163da9"
instance_type       = "t3.micro"
ec2_name_private1 = "bei2_ec2_private_1"
ec2_name_private2 = "bei2_ec2_private_2"

##sg
sg_desc = "Security group for back instance"
sg_name="back-instance-sg"

##other
igw_id              = "igw-03bbadaf5696df44a"
public_key_path     = "./terraform-key.pub"
kp_name="terraform-key"
nat_eip_name="nat-eip"
nat_name = "bei_nat"
igw_name = "bei_igw"