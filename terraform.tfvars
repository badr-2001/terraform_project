##vpc
vpc_id="vpc-0dc6afcbf4b2ee09d"
public_subnet_cidr="172.31.2.64/28"
private_subnet_cidr="172.31.2.80/28"
private_subnet_name="bei_private-subnet"
public_subnet_name="bei_public-subnet"

#ec2
ami = "ami-01f23391a59163da9"
instance_type="t3.micro"
ec2_name_front = "bei_front_instance"
ec2_name_back = "bei_back_instance"


#others
igw_id="igw-03bbadaf5696df44a"
igw_name="main-igw"
public_key_path = "./terraform-key.pub"
rt_name="public-route-table"
nat_eip_name = "nat-eip"
nat_name = "main-nat"
kp_name="terraform-key"