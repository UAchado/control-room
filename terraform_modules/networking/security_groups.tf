resource "aws_security_group" "lbs" {
  name        = "lb_sg"
  description = "Security Group for Inventory Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instances" {
  name        = "private_instances"
  description = "Security Group for EC2 Instances - APIs and UIs"
  vpc_id      = aws_vpc.main.id

  # allow inbound traffic on port 22 (ssh) from the public subnet
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_instances.id]
  }

  # allow inbound traffic from the public subnet on port 80 (ui)
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lbs.id]
  }

  # allow inbound traffic from the public subnet on port 8000 (api)
  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.lbs.id]
  }

  # allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "public_instances" {
  name        = "public_instances"
  description = "Security Group for EC2 Instances - Bastion Hosts"
  vpc_id      = aws_vpc.main.id

  # allow inbound traffic on port 22 (ssh) from the public subnet
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
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

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security Group for RDS Instances"
  vpc_id      = aws_vpc.main.id

  # allow inbound traffic on port 3306 (mysql) from the private instances
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.instances.id]
  }
}
