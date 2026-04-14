# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "myigw"
  }
}

# Fetch the main route table of the VPC
data "aws_route_table" "main" {
  vpc_id = aws_vpc.vpc1.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# Add a default route to the main route table
resource "aws_route" "internet_access" {
  route_table_id         = data.aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}