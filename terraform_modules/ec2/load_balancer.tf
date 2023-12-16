resource "aws_security_group" "ui_lb_sg" {
  name        = "ui-lb-sg"
  description = "Allow HTTP access to UI instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "lb" {
  name               = "uachado-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lbs_sg_id, aws_security_group.ui_lb_sg.id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.lb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
      type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "Not Found."
            status_code  = "404"
        }
    }
}

resource "aws_lb_listener_rule" "ui_rule" {
    listener_arn = aws_lb_listener.listener.arn
    priority     = 300

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.ui_tg.arn
    }

    condition {
        path_pattern {
            values = ["/*"]
        }
    }
}

resource "aws_lb_listener_rule" "points_rule" {
    listener_arn = aws_lb_listener.listener.arn
    priority     = 200

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.points_tg.arn
    }

    condition {
        path_pattern {
            values = ["/points/*"]
        }
    }
}

resource "aws_lb_listener_rule" "inventory_rule" {
    listener_arn = aws_lb_listener.listener.arn
    priority     = 100

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.inventory_tg.arn
    }

    condition {
        path_pattern {
            values = ["/inventory/*"]
        }
    }
}

resource "aws_lb_target_group" "ui_tg" {
  name        = "ui-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "points_tg" {
  name        = "points-target-group"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/points/v1"
  }
}

resource "aws_lb_target_group" "inventory_tg" {
  name        = "inventory-target-group"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/inventory/v1"
  }
}