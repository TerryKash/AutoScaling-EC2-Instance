resource "aws_autoscaling_group" "asg" {
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 2

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
}