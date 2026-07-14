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
resource "aws_vpc_security_group_ingress_rule" "allow_tls" {
  for_each          = toset(var.allowed_ports)
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_ipv4
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

#creating egress rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}