resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "main"
  }
}

locals {
  private_subnets = {
    a = {
      cidr_block = "10.0.10.0/24"
      az         = "ap-northeast-1a"
    }
    c = {
      cidr_block = "10.0.11.0/24"
      az         = "ap-northeast-1c"
    }
  }

  public_subnets = {
    a = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-northeast-1a"
    }
    c = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-northeast-1c"
    }
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true
  availability_zone       = each.value.az
  tags = {
    Name = "public-${each.key}"
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[each.key].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  tags = {
    Name = "private-${each.key}"
  }
}

resource "aws_route_table" "private" {
  for_each = local.private_subnets

  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[each.key].id
  }
}

resource "aws_route_table_association" "private" {
  for_each = local.private_subnets

  route_table_id = aws_route_table.private[each.key].id
  subnet_id      = aws_subnet.private[each.key].id
}

resource "aws_eip" "nat" {
  for_each = local.public_subnets

  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  # NAT Gatewayはインターネット接続が必要なのでパブリックサブネットに配置する必要がある
  for_each = local.public_subnets

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  depends_on = [aws_internet_gateway.main]
}
