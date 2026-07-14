resource "aws_autoscaling_policy" "cpu_target_scaling" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  name                   = "cpu-target-scaling"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    target_value = 50
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
  estimated_instance_warmup = 60

}