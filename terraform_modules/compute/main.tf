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

  vpc_security_group_ids = [ var.public_sg_id ]
  subnet_id              = var.public_subnet_id

  key_name = var.key_name

  user_data = file("${path.module}/init-scripts/user_ui.sh")

  tags = {
    Name = "User - UI"
    NatGatewayID = var.nat_gateway_id
  }

  depends_on = [aws_instance.inventory_api, aws_instance.drop_off_points_api ]
}

resource "aws_instance" "management_ui" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [ var.public_sg_id ]
  subnet_id              = var.public_subnet_id

  key_name = var.key_name

  tags = {
    Name = "Management-UI"
    NatGatewayID = var.nat_gateway_id
  }

  depends_on = [aws_instance.inventory_api, aws_instance.drop_off_points_api ]
}

resource "aws_instance" "drop_off_points_api" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [ var.private_sg_id ]
  subnet_id              = var.private_subnet_ids[0]

  key_name = var.key_name

  user_data = file("${path.module}/init-scripts/drop_off_points_api.sh")

  tags = {
    Name = "Drop-Off-Points-API"
    NatGatewayID = var.nat_gateway_id
  }
}

resource "aws_instance" "inventory_api" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [ var.private_sg_id ]
  subnet_id              = var.private_subnet_ids[1]

  key_name = var.key_name

  user_data = file("${path.module}/init-scripts/inventory_api.sh")

  tags = {
    Name = "Inventory-API"
    NatGatewayID = var.nat_gateway_id
  }
}