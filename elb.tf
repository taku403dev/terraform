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

# target group
resource "aws_alb_target_group" "alb_target_group" {
  name     = "${var.project}-${var.enviroment}-app-tg"
  port     = "3000"
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.enviroment}-app-tg"
    Project = var.project
    Env     = var.enviroment
  }
}

# ターゲットグループとEC2インスタンスの紐付け
resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_alb_target_group.alb_target_group.arn
  target_id        = aws_instance.app_server.id
}