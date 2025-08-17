variable "ami" { type = string }
variable "instance_type" { type = string }
variable "subnet_id" { type = string }
variable "associate_public_ip_address" { type = bool }
variable "sg_ids" { type = list(string) }
variable "key_name" { type = string }
variable "tag_name" { type = string }
variable "user_data" { type = string }
variable "user_data_replace_on_change" {
  type    = bool
  default = false
}
