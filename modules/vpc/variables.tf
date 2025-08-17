variable "existing_vpc_id" { type = string }
variable "cidr_block" {
  description = "CIDR for new VPC (only if create_vpc = true)"
  type        = string
  default     = null
}
variable "create_vpc" {
  type    = bool
  default = false
}
