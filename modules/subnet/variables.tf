variable "vpc_id" {
  type        = string
}

variable "cidr_block" {
  type        = string
}

variable "subnet_name" {
  type        = string
  default     = "my-subnet"
}

variable "availability_zone" {
  type        = string
  default     = null
}
