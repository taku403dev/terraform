# ECS

# cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-${var.enviroment}-ecs-cluster"
}

# # task
resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.project}-${var.enviroment}-ecs-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project}-${var.enviroment}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.arn
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 2
  #   platform_version                  = "1.3.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.web_sg.id
    ]
    subnets = [
      aws_subnet.private_subnet_1a.id,
      aws_subnet.private_subnet_1c.id,
    ]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group_ecs.arn
    container_name   = "ecs-container"
    container_port   = var.web_port
  }
  lifecycle {
    ignore_changes = [
      task_definition,
    ]
  }
}
