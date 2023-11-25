resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Security Group for Public Subnet - UIs"
  vpc_id      = var.vpc_id

  # allow all inbound traffic on port 80 (http)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all inbound traffic on port 22 (ssh)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Security Group for Private Subnets - APIs"
  vpc_id      = var.vpc_id

  # allow inbound traffic on port 22 (ssh) from the public subnet
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # allow inbound traffic from the public subnet on port 8000 (api)
  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security Group for RDS Instances"
  vpc_id      = var.vpc_id

  # allow inbound traffic on port 3306 (mysql) from the private subnet
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.private_sg.id]
  }
}