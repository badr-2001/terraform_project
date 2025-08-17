resource "aws_internet_gateway" "this" {
  count  = var.create_igw ? 1 : 0
  vpc_id = var.vpc_id
  tags   = { Name = var.igw_name }
}

data "aws_internet_gateway" "this" {
  count               = var.create_igw ? 0 : 1
  internet_gateway_id = var.existing_igw_id
}
