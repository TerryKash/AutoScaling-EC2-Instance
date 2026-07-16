resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier       = [aws_subnet.primary_subnet.id, aws_subnet.secondary_subnet.id]
  desired_capacity          = 1
  max_size                  = 2
  min_size                  = 1
  target_group_arns         = [aws_lb_target_group.alb_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-web-instance"
    propagate_at_launch = true
  }

}