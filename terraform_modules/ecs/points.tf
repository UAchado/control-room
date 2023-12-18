resource "aws_ecs_service" "drop_off_points_api_service" {
  name            = "drop-off-points-api-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.drop_off_points_api_task_definition.arn
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
    target_group_arn = var.drop_off_points_api_tg_arn
    container_name   = "uachado-drop-off-points-api"
    container_port   = 8000
  }
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
      image     = format("%s:%s", var.drop_off_points_api_image_repo, var.points_image_tag)
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
          awslogs-group         = "/ecs/uachado-drop-off-points-api"
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

resource "aws_cloudwatch_log_group" "points_log_group" {
  name              = "/ecs/uachado-drop-off-points-api"
  retention_in_days = 7
}

# resource "aws_appautoscaling_target" "points_target" {
#   max_capacity       = 2
#   min_capacity       = 1
#   resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.drop_off_points_api_service.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "points_policy" {
#   name               = "points-policy"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.points_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.points_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.points_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value       = 80.0
#     scale_in_cooldown  = 3000
#     scale_out_cooldown = 3000
#   }

# }
