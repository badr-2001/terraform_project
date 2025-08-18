variable "vpc_id"         { type = string }
variable "subnet_ids"     { type = list(string) }   # public subnets
variable "name"           { type = string }
variable "target_port"    { 
    type = number  
default = 80 
}
variable "target_ids"     { 
    type = list(string)
 default = [] 
 } # EC2 instance IDs
variable "allowed_ingress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]  # who can reach the ALB
}
