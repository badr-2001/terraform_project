variable "ami" {
  description = "AMI code for the EC2 instace"
  type = string
}

variable "instance_type" {
  description = "Instance type of EC2 (t3.micro , t2.medium ...)"
  type = string
  default = "t3.micro"
}