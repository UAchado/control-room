terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

# create a vpc with 256 ip addresses
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "UAchado VPC"
  }
}

# create public subnet with 128 addresses (var file)
resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidrs, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

# create 2 private subnets with 64 addresses (var file)
resource "aws_subnet" "private_subnets" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

# create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "UAchado Internet Gateway"
  }
}

# create route table so that the public subnet can access the internet
resource "aws_route_table" "internet_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "2nd Route Table"
  }
}

# associate the public subnet with the route table
resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.internet_rt.id
}

# allocate elastic ip
resource "aws_eip" "nat_eip" {
  instance = aws_instance.user_ui.id
}

# create nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnets[0].id

  tags = {
    Name = "UAchado NAT Gateway"
  }
}

# create route tables for private subnets
resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

}

# associate private subnets to the routing tables
resource "aws_route_table_association" "private_subnet1_asso" {
  subnet_id      = aws_subnet.private_subnets[0].id
  route_table_id = aws_route_table.private_rt1.id
}

resource "aws_route_table_association" "private_subnet2_asso" {
  subnet_id      = aws_subnet.private_subnets[1].id
  route_table_id = aws_route_table.private_rt2.id
}

# create security groups
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Security Group for Public Subnet - UIs"
  vpc_id      = aws_vpc.main.id

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
  vpc_id      = aws_vpc.main.id

  # allow inbound traffic on port 22 (ssh) from the public subnet
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # ingress {
  #   from_port       = <API_PORT>
  #   to_port         = <API_PORT>
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.public_sg.id]
  # }

  # allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# instantiate the ec2 instances
resource "aws_instance" "user_ui" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public_subnets[0].id

  key_name = "mankings"

  tags = {
    Name = "User - UI"
  }
}

resource "aws_instance" "management_ui" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public_subnets[0].id

  key_name = "mankings"

  tags = {
    Name = "Management-UI"
  }
}

resource "aws_instance" "drop_off_points_api" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.private_sg.id]
  subnet_id              = aws_subnet.private_subnets[0].id

  key_name = "mankings"

  tags = {
    Name = "Drop-Off-Points-API"
  }
}

resource "aws_instance" "inventory_api" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.private_sg.id]
  subnet_id              = aws_subnet.private_subnets[1].id

  key_name = "mankings"

  tags = {
    Name = "Inventory-API"
  }
}

# outputs
output "user_ui_ip" {
  value = aws_instance.user_ui.public_ip
}

output "management_ui_ip" {
  value = aws_instance.management_ui.public_ip
}

output "drop_off_points_api_ip" {
  value = aws_instance.drop_off_points_api.private_ip
}

output "inventory_api_ip" {
  value = aws_instance.inventory_api.private_ip
}
