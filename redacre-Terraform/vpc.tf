resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "${var.default_tag.Project}-vpc"
  }
  assign_generated_ipv6_cidr_block = true
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  enable_dns_support               = true
}

resource "aws_subnet" "public" {
  count  = var.public_subnet_count
  vpc_id = aws_vpc.main.id
  #this function will change 10.255.0.0/20 to 10.255.0.0/24.
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  #this function will change ipv6 cidr by 8 bits and will use the first available range.
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true
  tags = {
    "Name" = "${var.default_tag.Project}-public-${data.aws_availability_zones.available.names[count.index]}"
  }
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.default_tag.Project}-public-route table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  count = var.public_subnet_count
  #element fucntion will grab a single element from a list, it requeres 2 param.
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.default_tag.Project}-internet-gateway"
  }
}


resource "aws_subnet" "private" {
  count  = var.private_subnet_count
  vpc_id = aws_vpc.main.id
  
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + var.public_subnet_count)
  
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + var.public_subnet_count)
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false

  tags = {
    "Name" = "${var.default_tag.Project}-private-${data.aws_availability_zones.available.names[count.index]}"
  }
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "${var.default_tag.Project}-eip"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.0.id

  tags = {
    Name = "${var.default_tag.Project}-natgw"
  }

  depends_on = [aws_eip.nat_eip, aws_internet_gateway.gw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.default_tag.Project}-private-route table"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
}

resource "aws_route_table_association" "private" {
  count = var.private_subnet_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

