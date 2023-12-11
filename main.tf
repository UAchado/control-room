terraform {
  cloud {
    organization = "uachadomartelo"

    workspaces {
      name = "main"
    }
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

module "iam" {
  source = "./terraform_modules/iam"
}

module "networking" {
  source = "./terraform_modules/networking"
}

module "security" {
  source = "./terraform_modules/security"

  vpc_id = module.networking.vpc_id
}

module "database" {
  source = "./terraform_modules/database"

  private_subnet_ids = module.networking.private_subnet_ids

  inventory_db_user = var.inventory_db_user
  inventory_db_password = var.inventory_db_password
  inventory_db_name = var.inventory_db_name
  drop_off_points_db_user = var.drop_off_points_db_user
  drop_off_points_db_password = var.drop_off_points_db_password
  drop_off_points_db_name = var.drop_off_points_db_name

  rds_sg_id = module.security.rds_sg_id
}

module "ec2" {
  source = "./terraform_modules/ec2"

  vpc_id = module.networking.vpc_id

  public_subnet_ids = module.networking.public_subnet_ids
  public_sg_id = module.security.public_sg_id

  private_subnet_ids = module.networking.private_subnet_ids
  private_sg_id = module.security.private_sg_id

  key_name = module.iam.key_name

  # s3_bucket_name = module.database.s3_bucket_name
}

module "ecs" {
  source = "./terraform_modules/ecs"

  region = var.region
  public_subnet_ids = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids

  public_sg_id = module.security.public_sg_id
  private_sg_id = module.security.private_sg_id
  
  private_ecs_asg_arn = module.ec2.private_ecs_asg_arn
  
  user_ui_image = var.user_ui_image
  inventory_api_image_repo = var.inventory_api_image_repo
  drop_off_points_api_image_repo = var.drop_off_points_api_image_repo
  
  google_api_key = var.google_api_key
  inventory_lb_dns_name = module.ec2.inventory_lb_dns_name
  points_lb_dns_name = module.ec2.points_lb_dns_name

  inventory_db_connection_string = module.database.inventory_db_connection_string
  drop_off_points_db_connection_string = module.database.drop_off_points_db_connection_string

  user_ui_tg_arn = module.ec2.user_ui_tg_arn
  inventory_api_tg_arn = module.ec2.inventory_api_tg_arn
  drop_off_points_api_tg_arn = module.ec2.drop_off_points_api_tg_arn
}