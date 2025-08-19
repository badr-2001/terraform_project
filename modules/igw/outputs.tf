output "id" {
  value = var.create_igw ? aws_internet_gateway.this[0].id : data.aws_internet_gateway.this[0].id
}

##When we use count in Terraform, the resource becomes a list of objects, and each element corresponds to one instance of that resource