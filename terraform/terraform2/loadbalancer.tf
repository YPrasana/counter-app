# aws_lb #
resource "aws_lb" "nginx" {
  name               = "nginx-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]

  enable_deletion_protection = false


  tags = local.common_tags
}

# aws_lb_target_group #
resource "aws_lb_target_group" "nginx" {
  name     = "nginx-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  tags = local.common_tags
}



# aws_lb_listener #
resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

# aws_lb_target_group_attachment #
#alb target group attachment for 1st ec2 that in nginx1
resource "aws_lb_target_group_attachment" "nginx1" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx1.id
  port             = 80
}

#alb target group attachment for 2nd ec2 that in nginx2
resource "aws_lb_target_group_attachment" "nginx2" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx2.id
  port             = 80
}

#alb target group attachment for 3rd ec2 that in nginx3
resource "aws_lb_target_group_attachment" "nginx3" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx3.id
  port             = 80
}