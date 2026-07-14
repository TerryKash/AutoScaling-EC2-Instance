variable "region" {
  type = string
}
variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
variable "email" {
  type = string
}
variable "protocol" {
  type = string
}
variable "image_name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}

variable "ingress_rule" {
  type = map(object({
    port = number
    cidr = string
  }))
}

# variable "my_ip" {
#   type = string
# }

variable "subnet_cidr" {
  type = string
}

variable "cidr_block" {
  type = string
}