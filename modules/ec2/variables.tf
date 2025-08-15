variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "associate_public_ip_address" {
  type = bool
}

variable "sg_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "tag_name" {
  type = string
}