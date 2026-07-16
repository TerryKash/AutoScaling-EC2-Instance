#creating application load balancer
resource "aws_lb" "web_alb" {
  name               = "web-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.primary_subnet.id, aws_subnet.secondary_subnet.id]

}

#creating target group for load balancer
resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-tg-tf"
#   target_type = "alb"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    path     = "/"
    interval = 30
  }
}

#creating listener for load balancer
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}