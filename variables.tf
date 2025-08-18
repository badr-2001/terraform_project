variable "vpc_id" {
  type        = string
}

variable "igw_id" {
  type        = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "public_key_path" {
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "public_az" {
  type        = string
  default     = null
}

variable "private_az" {
  type        = string
  default     = null
}

variable "igw_name" {
  type = string
}
variable "public_subnet_name" {
  type = string
}
variable "private_subnet_name" {
  type = string
}

variable "rt_name" {
  type = string
}

variable "nat_eip_name" {
  type = string
}
variable "nat_name" {
  type = string
}
variable "kp_name" {
  type = string
}
variable "ec2_name_front" {
  type = string
}
variable "ec2_name_back" {
  type = string
}