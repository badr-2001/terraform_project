variable "create_igw" {
  type    = bool
  default = false
}
variable "existing_igw_id" { type = string }
variable "vpc_id" { type = string }
variable "igw_name" {
  type    = string
  default = "igw"
}
