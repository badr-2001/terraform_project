resource "aws_instance" "front_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = aws_key_pair.k8s_key.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  depends_on = [aws_key_pair.k8s_key]

  tags = {
    Name = "front_instance"
  }
}

resource "aws_instance" "back_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = aws_key_pair.k8s_key.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  depends_on = [aws_key_pair.k8s_key]

  tags = {
    Name = "back_instance"
  }
}