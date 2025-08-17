resource "aws_vpc" "this" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
}

data "aws_vpc" "this" {
  count = var.create_vpc ? 0 : 1
  id    = var.existing_vpc_id
}
