output "id" {
  value = var.create_vpc ? aws_vpc.this[0].id : data.aws_vpc.this[0].id
}
