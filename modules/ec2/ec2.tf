resource "aws_instance" "bei_front_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [var.sg_id]
  key_name = var.key_name


  tags = { Name = "bei_front_instance" }
}