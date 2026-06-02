resource "aws_security_group" "node-sg" {
  name        = "node-sg"
  description = "Allow kuber node required inbound traffic"
  vpc_id      = aws_vpc.vpc1.id   # attach to your VPC

  # Inbound rules
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Inbound rules
  ingress {
    description = "SSH from anywhere"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Inbound rules
  ingress {
    description = "SSH from anywhere"
    from_port   = 179
    to_port     = 179
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


# Inbound rules
  ingress {
    description = "SSH from anywhere"
    from_port   = 4789
    to_port     = 4789
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


# Inbound rules
  ingress {
    description = "SSH from anywhere"
    from_port   = 2379
    to_port     = 2379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


# Inbound rules
  ingress {
    description = "SSH from anywhere"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }


# Inbound rules
  ingress {
    description = "SSH from anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "4"
    cidr_blocks = ["0.0.0.0/0"]
  }


# Inbound rules
  ingress {
    description = "SSH from anywhere"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

# Outbound rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"   # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "node-sg"
  }
}
