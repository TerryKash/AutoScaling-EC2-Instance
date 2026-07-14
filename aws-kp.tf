#createing key-pair
resource "aws_key_pair" "key-tf" {
  key_name   = var.key_name
  public_key = file("${path.module}/id_rsa.pub")
}