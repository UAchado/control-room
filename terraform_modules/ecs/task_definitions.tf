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
      memory    = 1024
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
          name  = "INVENTORY_API_URL"
          value = var.inventory_api_url
        },
        {
          name  = "DROP_OFF_POINTS_API_URL"
          value = var.drop_off_points_api_url
        }

      ]
    }
  ])
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
      image     = var.inventory_api_image
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
          awslogs-group         = "uachado-inventory-api"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "INVENTORY_DB_CONNECTION_STRING"
          value = var.inventory_db_connection_string
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "drop_off_points_api_task_definition" {
  family             = "drop-off-points-api-task"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::334642795591:role/ecsTaskExecutionRole"
  cpu                = 256

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "uachado-drop-off-points-api"
      image     = var.drop_off_points_api_image
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
          awslogs-group         = "uachado-drop-off-points-api"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "DROP_OFF_POINTS_DB_CONNECTION_STRING"
          value = var.drop_off_points_db_connection_string
        }
      ]
    }
  ])
}
