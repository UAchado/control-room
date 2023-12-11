resource "aws_lb" "ui_lb" {
  name               = "ui-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "ui" {
  load_balancer_arn = aws_lb.ui_lb.arn
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
    path                = "/"
    interval            = 60
    timeout             = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb" "inventory_lb" {
  name               = "inventory-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "inventory" {
  load_balancer_arn = aws_lb.inventory_lb.arn
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

resource "aws_lb" "points_lb" {
  name               = "points-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "points" {
  load_balancer_arn = aws_lb.points_lb.arn
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
