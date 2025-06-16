resource "aws_security_group" "web_sg" {
  name   = "web-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 8080
    to_port     = 8084
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "webapp" {
  family                   = "java-webapp"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([{
    name      = "webapp"
    image     = "${var.ecr_repo_url}:${var.image_version}"
    essential = true
    portMappings = [{ containerPort = 8080, hostPort = 8080 }]
  }])
}

resource "aws_ecs_service" "webapp" {
  name            = "webapp-service"
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.webapp.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.public_subnets
    security_groups = [aws_security_group.web_sg.id]
    assign_public_ip = true
  }
}