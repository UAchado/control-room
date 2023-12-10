resource "aws_lb" "user_ui_lb" {
  name               = "user-ui-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "user_ui_listener" {
  load_balancer_arn = aws_lb.user_ui_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_ui_tg.arn
  }
}

resource "aws_lb_target_group" "user_ui_tg" {
  name        = "user-ui-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
    interval = 60
    timeout = 30
    healthy_threshold = 2
    unhealthy_threshold = 3
  }
}

resource "aws_alb" "inventory_api_lb" {
  name               = "inventory-api-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "inventory_api_listener" {
  load_balancer_arn = aws_alb.inventory_api_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inventory_api_tg.arn
  }
}

resource "aws_lb_target_group" "inventory_api_tg" {
  name        = "inventory-api-target-group"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/v1/"
  }
}

resource "aws_lb" "drop_off_points_api_lb" {
  name               = "drop-off-points-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "drop_off_points_api_listener" {
  load_balancer_arn = aws_lb.drop_off_points_api_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.drop_off_points_api_tg.arn
  }
}

resource "aws_lb_target_group" "drop_off_points_api_tg" {
  name        = "drop-off-points-api-target-group"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/v1/"
  }
}
