resource "aws_route_table_association" "attach1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route1.id
}

resource "aws_route_table_association" "attach2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route1.id
}

resource "aws_route_table_association" "attach3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.route1.id
}
