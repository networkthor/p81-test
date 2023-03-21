// Create new VPC for environment

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags   = {
    Name       = "${var.project_name}-vpc"
    Owner      = "Nati"
    Department = "DevOps"
    Temp       = "TRUE"
  }
}

// Availability zones

data "aws_availability_zones" "available" {}

// Create new public subnets for VPC

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                           = "${var.project_name}-public-${count.index + 1}"
    "kubernetes.io/cluster/${var.project_name}-cluster" = "shared"
    "kubernetes.io/role/elb"                       = 1
    Owner                                          = "Nati"
    Department                                     = "DevOps"
    Temp                                           = "TRUE"
  }
}

// Create new private subnets for VPC

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                                = "${var.project_name}-private-${count.index + 1}"
    "kubernetes.io/cluster/${var.project_name}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                   = 1
    Owner                                               = "Nati"
    Department                                          = "DevOps"
    Temp                                                = "TRUE"
  }
}

// Create internet gateway for VPC

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name       = "${var.project_name}-igw"
    Owner      = "Nati"
    Department = "DevOps"
    Temp       = "TRUE"
  }
}

// Create Elastic IPs for NAT gateways

resource "aws_eip" "eip" {
  count = length(var.private_subnets)

  tags = {
    Name       = "${var.project_name}-ngw-eip-${count.index + 1}"
    Owner      = "Nati"
    Department = "DevOps"
    Temp       = "TRUE"
  }
}

// Create NAT gateways

resource "aws_nat_gateway" "ngw" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.eip[*].id, count.index)
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags   = {
    Name       = "${var.project_name}-ngw-${count.index + 1}"
    Owner      = "Nati"
    Department = "DevOps"
    Temp       = "TRUE"
  }
}

// Create route table for VPC

/// Create public route table and associate it with internet-gateway
resource "aws_route_table" "public_rt" {
  vpc_id        = aws_vpc.vpc.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name       = "${var.project_name}-public-rt"
    Owner      = "Nati"
    Department = "DevOps"
    Temp       = "TRUE"
  }
}

resource "aws_route_table" "private_rt" {
  count         = length(var.private_subnets)
  vpc_id        = aws_vpc.vpc.id
  
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = element(aws_nat_gateway.ngw[*].id, count.index)
  }

  tags = {
    Name       = "${var.project_name}-private-rt-${count.index + 1}"
    Owner      = "Nati"
    Department = "DevOps"
    Temp       = "TRUE"
  }
}

resource "aws_route_table_association" "public_route_assoc" {
  count          = length(aws_subnet.public_subnets[*].id)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_route_assoc" {
  count          = length(aws_subnet.private_subnets[*].id)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.private_rt[*].id, count.index)
}