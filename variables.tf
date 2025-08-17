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
