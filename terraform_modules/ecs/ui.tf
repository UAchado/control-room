resource "aws_ecs_service" "user_ui_service" {
  name            = "user-ui-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.user_ui_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.instances_sg_id]
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.user_ui_tg_arn
    container_name   = "uachado-user-ui"
    container_port   = 80
  }
}

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
      image     = format("%s:%s", var.user_ui_image, var.user_ui_image_tag)
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
          value = "https://uachado.pt/inventory/v1/"

        },
        {
          name  = "VITE_POINTS_URL"
          value = "https://uachado.pt/points/v1/"

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