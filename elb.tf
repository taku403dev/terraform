# ALB
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.enviroment}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.web_sg.id
  ]
  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]
}

# ECS target group
resource "aws_lb_target_group" "alb_target_group_ecs" {
  name                 = "${var.project}-${var.enviroment}-ecs-tg"
  target_type          = "ip"
  port                 = var.web_port
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc.id
  deregistration_delay = 300

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.alb]

  tags = {
    Name    = "${var.project}-${var.enviroment}-ecs-tg"
    Project = var.project
    Env     = var.enviroment
  }
}

# target group
# resource "aws_lb_target_group" "alb_target_group" {
#   name     = "${var.project}-${var.enviroment}-app-tg"
#   port     = var.app_port
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc.id
#   tags = {
#     Name    = "${var.project}-${var.enviroment}-app-tg"
#     Project = var.project
#     Env     = var.enviroment
#   }
# }

# Elb listener
# resource "aws_lb_listener" "alb_listener_http" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = var.web_port
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_group.arn
#   }
# }

# Elb ECS listener
resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.web_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_ecs.arn
  }
}
# ターゲットグループとEC2インスタンスの紐付け
# resource "aws_lb_target_group_attachment" "instance" {
#   target_group_arn = aws_lb_target_group.alb_target_group.arn
#   target_id        = aws_instance.app_server.id
# }