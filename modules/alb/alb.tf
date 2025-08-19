
resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = "application"
  internal           = false ##the ALB gets public IPs and a public DNS name.
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alb_sg.id] ##subnets must be public (route to an Internet Gateway)
  access_logs {
    bucket  = var.log_bucket_name
    prefix  = "alb"
    enabled = true
  }
  
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-sg"
  description = "ALB SG"
  vpc_id      = var.vpc_id


  ingress { # Who can call the ALB
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  egress { # Where the ALB can connect out to
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
   
    cidr_blocks = ["0.0.0.0/0"]
  }
}


##where we send traffic
resource "aws_lb_target_group" "tg" {
  name        = "${var.name}-tg"
  vpc_id      = var.vpc_id
  port        = var.target_port
  protocol    = "HTTP"
  target_type = "instance" ##ec2

  health_check { ##ALB hits http://<instance-private-ip> and marks the target healthy/unhealthy.
    protocol = "HTTP"
    path     = "/"
    port     = "traffic-port"
  }
}

##attaches each EC2 instance to the target group.
resource "aws_lb_target_group_attachment" "att" {
    for_each = { for idx, id in var.target_ids : tostring(idx) => id }
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
  port             = var.target_port
}

#The listener is the ALB’s “front door”, it listens on the port i specify "80"
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
