resource "aws_ecs_service" "inventory_api_service" {
  name            = "inventory-api-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.inventory_api_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.instances_sg_id]
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.inventory_api_tg_arn
    container_name   = "uachado-inventory-api"
    container_port   = 8000
  }
}

resource "aws_ecs_task_definition" "inventory_api_task_definition" {
  family             = "inventory-api-task"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::334642795591:role/ecsTaskExecutionRole"
  cpu                = 256

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "uachado-inventory-api"
      image     = format("%s:%s", var.inventory_api_image_repo, var.inventory_image_tag)
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/uachado-inventory-api"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "DATABASE_URL"
          value = var.inventory_db_connection_string
        },
        {
          name  = "SMTP_SERVER"
          value = var.smtp_server
        },
        {
          name  = "SMTP_PORT"
          value = var.smtp_port
        },
        {
          name  = "EMAIL_USERNAME"
          value = var.email_username
        },
        {
          name  = "EMAIL_PASSWORD"
          value = var.email_password
        },
        {
          name  = "COGNITO_ISSUER"
          value = var.cognito_issuer
        },
        {
          name  = "COGNITO_AUDIENCE"
          value = var.cognito_audience
        },
        {
          name = "AWS_BUCKET_NAME"
          value = var.s3_bucket_name
        },
        {
          name = "AWS_ACCESS_KEY_ID"
          value = var.boto3_access_key
        },
        {
          name = "AWS_SECRET_ACCESS_KEY"
          value = var.boto3_secret_key
        }
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "inventory_api_log_group" {
  name              = "/ecs/uachado-inventory-api"
  retention_in_days = 7
}