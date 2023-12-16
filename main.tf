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

  public_key = var.public_key
}

module "networking" {
  source = "./terraform_modules/networking"
}

module "database" {
  source = "./terraform_modules/database"

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  rds_sg_id          = module.networking.rds_sg_id

  inventory_db_user     = var.inventory_db_user
  inventory_db_password = var.inventory_db_password
  inventory_db_name     = var.inventory_db_name

  drop_off_points_db_user     = var.drop_off_points_db_user
  drop_off_points_db_password = var.drop_off_points_db_password
  drop_off_points_db_name     = var.drop_off_points_db_name
}

module "ec2" {
  source = "./terraform_modules/ec2"

  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids

  key_name = module.iam.key_name

  lbs_sg_id              = module.networking.lbs_sg_id
  instances_sg_id        = module.networking.instances_sg_id
  public_instances_sg_id = module.networking.public_instances_sg_id

  # s3_bucket_name = module.database.s3_bucket_name
}

module "ecs" {
  source = "./terraform_modules/ecs"

  # infrastructure & security
  region             = var.region
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  instances_sg_id    = module.networking.instances_sg_id

  ecs_asg_arn                = module.ec2.ecs_asg_arn
  user_ui_tg_arn             = module.ec2.user_ui_tg_arn
  inventory_api_tg_arn       = module.ec2.inventory_api_tg_arn
  drop_off_points_api_tg_arn = module.ec2.drop_off_points_api_tg_arn

  # docker images
  user_ui_image                  = var.user_ui_image
  inventory_api_image_repo       = var.inventory_api_image_repo
  drop_off_points_api_image_repo = var.drop_off_points_api_image_repo

  # ui env vars
  inventory_lb_dns_name       = module.ec2.inventory_lb_dns_name
  points_lb_dns_name          = module.ec2.points_lb_dns_name
  google_api_key              = var.google_api_key
  vite_client_id              = var.vite_client_id
  vite_client_secret          = var.vite_client_secret
  vite_cognito_code_endpoint  = var.vite_cognito_code_endpoint
  vite_cognito_token_endpoint = var.vite_cognito_token_endpoint
  vite_redirect_uri           = var.vite_redirect_uri

  # api env vars
  drop_off_points_db_connection_string = module.database.drop_off_points_db_connection_string
  inventory_db_connection_string       = module.database.inventory_db_connection_string
  cognito_issuer                       = var.cognito_issuer
  cognito_audience                     = var.cognito_audience
  smtp_server                          = var.smtp_server
  smtp_port                            = var.smtp_port
  email_username                       = var.email_username
  email_password                       = var.email_password
}
