resource "aws_ecs_service" "user_ui_service" {
  name            = "user-ui-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
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

  task_definition = replace(
    aws_ecs_task_definition.user_ui_task_definition.arn,
    "revision",
    format("revision-%s", timestamp())
  )
}

resource "aws_ecs_service" "inventory_api_service" {
  name            = "inventory-api-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
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

  task_definition = replace(
    aws_ecs_task_definition.inventory_api_task_definition.arn,
    "revision",
    format("revision-%s", timestamp())
  )
}

resource "aws_ecs_service" "drop_off_points_api_service" {
  name            = "drop-off-points-api-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
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

  task_definition = replace(
    aws_ecs_task_definition.drop_off_points_api_task_definition.arn,
    "revision",
    format("revision-%s", timestamp())
  )
}
