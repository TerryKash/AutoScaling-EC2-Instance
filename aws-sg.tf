#creating security group for alb
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow TLS inbound traffic from ALB only"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "alb-sg"
  }
}

#creating ingress rule from alb
resource "aws_vpc_security_group_ingress_rule" "allow_http_from_alb" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#creating security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

#creating ingress rule
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  # for_each          = var.ingress_rule
  security_group_id            = aws_security_group.allow_tls.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  # cidr_ipv4         = each.value.cidr
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  # for_each          = var.ingress_rule
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.my_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

#creating egress rule for ec2
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

# #creating egress rule for ALB send traffic out to your backend EC2 instances
resource "aws_vpc_security_group_egress_rule" "alb_allow_all_outbound" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}