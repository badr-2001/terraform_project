variable "existing_igw_id" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "create_igw" {
  type    = bool
  default = false
}

variable "igw_name" {
  type = string
}
