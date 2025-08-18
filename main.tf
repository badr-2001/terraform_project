## vpc
variable "vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for public subnet"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR for private subnet"
}

variable "public_subnet_name" {
  type        = string
  description = "Name tag for public subnet"
}

variable "private_subnet_name" {
  type        = string
  description = "Name tag for private subnet"
}

## ec2
variable "ami" {
  type        = string
  description = "AMI ID for instances"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "ec2_name_front" {
  type        = string
  description = "Name tag for front EC2"
}

variable "ec2_name_back" {
  type        = string
  description = "Name tag for back EC2"
}

## igw
variable "igw_id" {
  type        = string
  description = "Existing Internet Gateway ID attached to the VPC"
}

variable "igw_name" {
  type        = string
  description = "(Unused here; kept for parity if you later create IGW via resource)"
  default     = "main-igw"
}

## key pair
variable "public_key_path" {
  type        = string
  description = "Path to the public key file to upload"
}

variable "kp_name" {
  type        = string
  description = "Key pair name"
}

## route table / nat names
variable "rt_name" {
  type        = string
  description = "Name tag for the public route table"
}

variable "nat_eip_name" {
  type        = string
  description = "Name tag for the NAT EIP"
}

variable "nat_name" {
  type        = string
  description = "Name tag for the NAT Gateway"
}

output "front_public_ip"  { value = aws_instance.bei_front_instance.public_ip }
output "back_private_ip"  { value = aws_instance.bei_back_instance.private_ip }
