resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  tags   = { Name = var.name }

  dynamic "route" {
    for_each = var.routes
    content {
      cidr_block     = route.value.cidr_block
      gateway_id     = try(route.value.gateway_id, null)
      nat_gateway_id = try(route.value.nat_gateway_id, null)
    }
  }
}
