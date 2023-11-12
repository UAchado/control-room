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
  region = "us-west-2"
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
  instance = null
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

  # allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# instance image
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# instantiate the ec2 instances
resource "aws_instance" "user_ui" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public_subnets[0].id

  key_name = "mankings"

  user_data = file("${path.module}/init-scripts/user_ui.sh")

  tags = {
    Name = "User - UI"
  }
}

resource "aws_instance" "management_ui" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public_subnets[0].id

  key_name = "mankings"

  tags = {
    Name = "Management-UI"
  }
}

resource "aws_instance" "drop_off_points_api" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.private_sg.id]
  subnet_id              = aws_subnet.private_subnets[0].id

  key_name = "mankings"

  user_data = file("${path.module}/init-scripts/drop_off_points_api.sh")

  tags = {
    Name = "Drop-Off-Points-API"
  }
}

resource "aws_instance" "inventory_api" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.private_sg.id]
  subnet_id              = aws_subnet.private_subnets[1].id

  key_name = "mankings"

  user_data = file("${path.module}/init-scripts/inventory_api.sh")

  tags = {
    Name = "Inventory-API"
  }
}

# data storage
resource "aws_db_subnet_group" "drop_off_points_db_subnet_group" {
  name       = "drop_off_points_db_subnet_group"
  subnet_ids = [aws_subnet.private_subnets[0].id]

  tags = {
    Name = "Drop-Off-Points DB Subnet Group"
  }
}

resource "aws_db_subnet_group" "inventory_db_subnet_group" {
  name       = "inventory_db_subnet_group"
  subnet_ids = [aws_subnet.private_subnets[1].id]

  tags = {
    Name = "Inventory DB Subnet Group"
  }
}
resource "aws_db_instance" "inventory_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  username             = var.inventory_db_user
  password             = var.inventory_db_password
  db_subnet_group_name = aws_db_subnet_group.inventory_db_subnet_group.name
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false

  tags = {
    Name = "Inventory MYSQL Database"
  }
}

resource "aws_db_instance" "drop_off_points_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  username             = var.drop_off_points_db_user
  password             = var.drop_off_points_db_password
  db_subnet_group_name = aws_db_subnet_group.drop_off_points_db_subnet_group.name
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false

  tags = {
    Name = "Drop-Off-Points MYSQL Database"
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
