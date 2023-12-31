resource "aws_db_subnet_group" "drop_off_points_db_subnet_group" {
  name       = "drop_off_points_db_subnet_group"
  subnet_ids = [var.private_subnet_ids[0], var.private_subnet_ids[1]]

  tags = {
    Name = "Drop-Off-Points DB Subnet Group"
  }
}

resource "aws_db_subnet_group" "inventory_db_subnet_group" {
  name       = "inventory_db_subnet_group"
  subnet_ids = [var.private_subnet_ids[0], var.private_subnet_ids[1]]

  tags = {
    Name = "Inventory DB Subnet Group"
  }
}

resource "aws_db_instance" "inventory_db" {
  db_name              = var.inventory_db_name
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
  identifier           = "inventory-db"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  monitoring_interval = 60

  tags = {
    Name = "Inventory MYSQL Database"
  }
}

resource "aws_db_instance" "drop_off_points_db" {
  db_name              = var.drop_off_points_db_name
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
  identifier           = "points-db"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  monitoring_interval = 60

  tags = {
    Name = "Drop-Off-Points MYSQL Database"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security Group for RDS Instances"
  vpc_id      = var.vpc_id

  # allow inbound traffic on port 3306 (mysql) from the private instances
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }
}
