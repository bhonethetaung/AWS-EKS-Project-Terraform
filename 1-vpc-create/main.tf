resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_eip" "nat-eip" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw-${var.vpc_name}"
  }
}

resource "aws_subnet" "public_sub" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "${var.vpc_name}-public-sub-${count.index+1}"
  }
}

resource "aws_subnet" "private_sub" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "${var.vpc_name}-private-sub-${count.index+1}"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_sub[0].id
  tags = {
    Name = "nat-gw-${var.vpc_name}"
  }
  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "internet-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public rtb-${var.vpc_name}"
  }
}

resource "aws_route_table" "nat-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "private rtb-${var.vpc_name}"
  }
}

resource "aws_route_table_association" "public-rtb-assoc" {
  count = length(var.public_subnets)
  subnet_id      = aws_subnet.public_sub[count.index].id
  route_table_id = aws_route_table.internet-rtb.id
}

resource "aws_route_table_association" "private-rtb-assoc" {
  count = length(var.private_subnets)
  subnet_id      = aws_subnet.private_sub[count.index].id
  route_table_id = aws_route_table.nat-rtb.id
}
