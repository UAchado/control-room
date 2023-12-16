resource "aws_ecs_task_definition" "user_ui_task_definition" {
  family             = "user-ui-task"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::334642795591:role/ecsTaskExecutionRole"
  cpu                = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "uachado-user-ui"
      image     = var.user_ui_image
      cpu       = 512
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "uachado-user-ui"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [

        {
          name  = "VITE_INVENTORY_URL"
          value = "http://${var.inventory_lb_dns_name}/inventory/v1/"
        },
        {
          name  = "VITE_POINTS_URL"
          value = "http://${var.points_lb_dns_name}/points/v1/"
        },
        {
          name  = "VITE_API_KEY"
          value = "${var.google_api_key}"
        },
        {
          name  = "VITE_CLIENT_ID"
          value = var.vite_client_id
        },
        {
          name  = "VITE_CLIENT_SECRET"
          value = var.vite_client_secret
        },
        {
          name  = "VITE_COGNITO_CODE_ENDPOINT"
          value = var.vite_cognito_code_endpoint
        },
        {
          name  = "VITE_COGNITO_TOKEN_ENDPOINT"
          value = var.vite_cognito_token_endpoint
        },
        {
          name  = "VITE_REDIRECT_URI"
          value = var.vite_redirect_uri
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "inventory_api_task_definition" {
  family             = "inventory-api-task"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::334642795591:role/ecsTaskExecutionRole"
  cpu                = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "uachado-inventory-api"
      image     = var.inventory_api_image_repo
      cpu       = 512
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
          awslogs-group         = "uachado-inventory-api"
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
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "drop_off_points_api_task_definition" {
  family             = "drop-off-points-api-task"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::334642795591:role/ecsTaskExecutionRole"
  cpu                = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "uachado-drop-off-points-api"
      image     = var.drop_off_points_api_image_repo
      cpu       = 512
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
          awslogs-group         = "uachado-drop-off-points-api"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "DATABASE_URL"
          value = var.drop_off_points_db_connection_string
        },
        {
          name  = "COGNITO_ISSUER"
          value = var.cognito_issuer
        },
        {
          name  = "COGNITO_AUDIENCE"
          value = var.cognito_audience
        }
      ]
    }
  ])
}
