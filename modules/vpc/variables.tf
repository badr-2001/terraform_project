variable "existing_vpc_id" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "create_vpc" {
  type    = bool
  default = false
}