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
  name        = "nginx-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_default_vpc.default.id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout            = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

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
#alb target group attachment for autoscaling group
# resource "aws_autoscaling_attachment" "nginx" {
#   autoscaling_group_name = aws_autoscaling_group.nginx_asg.name
#   target_group_arn   = aws_lb_target_group.nginx.arn
# }

resource "aws_lb_target_group_attachment" "nginx_alb_attachment" {
  count            = length(aws_autoscaling_group.nginx_asg)

  target_group_arn = aws_lb_target_group.nginx.arn
  #target_type      = "instance"
  port             = 80
  #depends_on       = [aws_autoscaling_group.nginx_asg]
  target_id        = element(aws_autoscaling_group.nginx_asg.*.name, count.index)
  #propagate_at_launch    = true
}

resource "aws_autoscaling_attachment" "nginx_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.name
  lb_target_group_arn   = aws_lb_target_group.nginx.arn
}

