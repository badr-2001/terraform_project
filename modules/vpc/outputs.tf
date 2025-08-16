output "vpc_id" {
  value = var.create_vpc ? aws_vpc.vpc[0].id : data.aws_vpc.vpc[0].id
}