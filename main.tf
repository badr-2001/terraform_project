## EC2 Instances ---------------------------------------
resource "aws_instance" "front_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id

  tags = {
    Name = "front_instance"
  }
}

resource "aws_instance" "back_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id

  tags = {
    Name = "back_instance"
  }
}

## VPC -----------------------------------------
data "aws_vpc" "main_vpc" {
   id = var.vpc_id
}