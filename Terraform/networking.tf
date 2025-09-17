resource "aws_vpc" "vedant_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "vedant-vpc"
  }
}

resource "aws_subnet" "vedant_subnet" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.vedant_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vedant_vpc.cidr_block, 8, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "vedant-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "vedant_igw" {
  vpc_id = aws_vpc.vedant_vpc.id
  tags = {
    Name = "vedant-igw"
  }
}

resource "aws_route_table" "vedant_route_table" {
  vpc_id = aws_vpc.vedant_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vedant_igw.id
  }

  tags = {
    Name = "vedant-route-table"
  }
}

resource "aws_route_table_association" "vedant_rt_assoc" {
  count          = length(aws_subnet.vedant_subnet)
  subnet_id      = aws_subnet.vedant_subnet[count.index].id
  route_table_id = aws_route_table.vedant_route_table.id
}
