locals {
  tags = {
    "cost_center" = var.cost_center
    "tag_for_fun" = "it's working!"
  }
}

###
# VPC
###
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = local.tags

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [cidr_block]
  }
}

###
# Subnet
###
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = local.tags
}

###
# Internet Gateway
###

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = local.tags
}

###
# Public routes
###
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = local.tags

}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id

  timeouts {
    create = "5m"
  }
}

###
# Route Table association
###

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}