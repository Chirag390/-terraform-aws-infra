resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Name = "${var.project_name}-${var.environment}-vpc" })
}

# Create one public subnet per CIDR
resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, index(tolist(var.public_subnets_cidrs), each.value))
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-public-${each.key}" })
}

# Create one private subnet per CIDR
resource "aws_subnet" "private" {
  for_each = toset(var.private_subnets_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = element(data.aws_availability_zones.available.names, index(tolist(var.private_subnets_cidrs), each.value))
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-private-${each.key}" })
}

data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.project_name}-${var.environment}-igw" })
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-public-rt" })
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway + private route table (single NAT per AZ recommended)
resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  vpc = true
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-nat-eip-${each.key}" })
}

resource "aws_nat_gateway" "natgw" {
  for_each = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-nat-${each.key}" })
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw[each.key].id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-private-rt-${each.key}" })
}

resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private
  subnet_id = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

# DB subnet group (for RDS)
resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = values(aws_subnet.private)[*].id
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-db-subnet-group" })
}

