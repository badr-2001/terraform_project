output "id" {
  value = var.create_igw ? aws_internet_gateway.this[0].id : data.aws_internet_gateway.this[0].id
}
