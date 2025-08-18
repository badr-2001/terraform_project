variable "vpc_id" {
  type        = string
}

variable "igw_id" {
  type        = string
}

variable "public_subnet1_cidr" {
  type = string
}

variable "private_subnet1_cidr" {
  type = string
}
variable "public_subnet2_cidr" {
  type = string
}

variable "private_subnet2_cidr" {
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

variable "public_subnet_az1" {
  type = string
}
variable "private_subnet_az1" {
  type = string
}
variable "public_subnet_az2" {
  type = string
}
variable "private_subnet_az2" {
  type = string
}

variable "public_subnet_name1" {
    type = string
}
variable "private_subnet_name1" {
    type = string
}
variable "public_subnet_name2" {
    type = string
}
variable "private_subnet_name2" {
    type = string
}

variable "ec2_name_private1" {
  type = string
}
variable "ec2_name_private2" {
  type = string
}
variable "sg_desc" {
  type=string
}
variable "sg_name" {
  type = string
}
variable "kp_name" {
  type = string
}