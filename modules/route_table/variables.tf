variable "vpc_id" { type = string }
variable "name" { type = string }
variable "routes" {
  type = list(object({
    cidr_block     = string
    gateway_id     = optional(string)
    nat_gateway_id = optional(string)
  }))
  default = []
}
