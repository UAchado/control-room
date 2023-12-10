resource "aws_ecs_capacity_provider" "private" {
  name = "private-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.private_ecs_asg_arn

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "asso" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.private.name]
}