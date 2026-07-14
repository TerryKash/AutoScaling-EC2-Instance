#creating data source
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = [var.image_name]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#creating launch template
resource "aws_launch_template" "ec2_launch_template" {
  name_prefix            = "ec2-launch-"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  user_data              = filebase64("${path.module}/script.sh")
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = aws_key_pair.key-tf.id

  tags = {
    Name = "ec2-instance"
  }
}