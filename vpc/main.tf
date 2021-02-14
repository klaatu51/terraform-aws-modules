locals {
  common_tags = map(
    "Name", "terraform-eks-demo"
  )
}

resource "aws_vpc" "demo" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true

    tags = merge(
        local.common_tags
    )
}

resource "aws_subnet" "public" {
    count = length(var.public_subnets)

    availability_zone = data.aws_availability_zones.available.names[count.index]
    cidr_block = element(var.public_subnets, count.index)
    vpc_id = aws_vpc.demo.id


    tags = merge(
        local.common_tags
    )
}

resource "aws_subnet" "private" {
    count = length(var.private_subnets)

    availability_zone = data.aws_availability_zones.available.names[count.index]
    cidr_block = element(var.private_subnets, count.index)
    vpc_id = aws_vpc.demo.id


    tags = merge(
        local.common_tags
    )
}

resource "aws_internet_gateway" "demo" {
    vpc_id = aws_vpc.demo.id

    tags = merge(
        local.common_tags
    )
}

resource "aws_eip" "demo" {
    count = var.single_nat_gateway ? 1 : length(var.public_subnets)

    vpc = true
}

resource "aws_nat_gateway" "demo" {
    count = var.single_nat_gateway ? 1 : length(var.public_subnets)

    allocation_id = element(
        aws_eip.demo.*.id,
        var.single_nat_gateway ? 0 : count.index
  )
    subnet_id = element(
        aws_subnet.public.*.id,
        var.single_nat_gateway ? 0 : count.index
  )
    depends_on = [aws_internet_gateway.demo]
}

resource "aws_route_table" "public" {
    count = var.single_nat_gateway ? 1 : length(var.public_subnets)
    vpc_id = aws_vpc.demo.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo.id
    }
}

resource "aws_route_table" "private" {
    count = var.single_nat_gateway ? 1 : length(var.public_subnets)
    vpc_id = aws_vpc.demo.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = element(aws_nat_gateway.demo.*.id, count.index)
    }
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnets)

    subnet_id = element(aws_subnet.public.*.id, count.index)
    route_table_id = element(aws_route_table.public.*.id, count.index)
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnets)

    subnet_id = element(aws_subnet.private.*.id, count.index)
    route_table_id = element(aws_route_table.private.*.id, count.index)
}