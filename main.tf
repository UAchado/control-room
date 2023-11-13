terraform {
  # cloud {
  #   organization = "UAchado_Org"
  #   workspaces {
  #     name = "control-room"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-1"
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
  drop_off_points_db_user = var.drop_off_points_db_user
  drop_off_points_db_password = var.drop_off_points_db_password
}

module "compute" {
  source = "./terraform_modules/compute"

  public_subnet_id = module.networking.public_subnet_id
  public_sg_id = module.security.public_sg_id

  private_subnet_ids = module.networking.private_subnet_ids
  private_sg_id = module.security.private_sg_id

  nat_gateway_id = module.networking.nat_gateway_id

  key_name = module.iam.key_name
}
