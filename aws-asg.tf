resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.primary_subnet.id, aws_subnet.secondary_subnet.id]
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

}