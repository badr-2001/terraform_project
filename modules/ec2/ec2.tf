resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = var.sg_ids
  key_name                    = var.key_name
  user_data                   = var.user_data
  user_data_replace_on_change = var.user_data_replace_on_change

  tags = { Name = var.tag_name }
}
