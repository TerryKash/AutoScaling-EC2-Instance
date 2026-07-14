#sourcing AZ
data "aws_availability_zones" "available" {
  state = "available"
}

#creating vpc
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

#creating 2 subnets primary and secondary 
resource "aws_subnet" "primary_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.subnet_cidr, 8, 1)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "primary-subnet"
  }
}

resource "aws_subnet" "secondary_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.subnet_cidr, 8, 1)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "secondary-subnet"
  }
}

#creating internet gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

#creating route table for internet gateway
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id # Tells AWS this map belongs to your neighborhood

  route {
    cidr_block = "0.0.0.0/0"                     # "If traffic wants to go to the Entire Internet..."
    gateway_id = aws_internet_gateway.gateway.id # "...send it directly to our Front Gate"
  }

  tags = { Name = "main-route-table" }
}

#creating route table association for route table
resource "aws_route_table_association" "primary_assoc" {
  subnet_id      = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "secondary_assoc" {
  subnet_id      = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.rt.id
}