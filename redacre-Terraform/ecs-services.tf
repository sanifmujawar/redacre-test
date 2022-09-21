# For better scalability I decided to use 1 to 1 relation, one service for one task definition(ecr image).
# Both ecs-services are running under private networks
# Each ecs-service is conected to the same load balancer.

resource "aws_ecs_service" "redacre" {
  name            = "${var.default_tag.Project}-service"
  cluster         = aws_ecs_cluster.red_acre.arn
  task_definition = aws_ecs_task_definition.redacre.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.aws_tg.arn
    container_name   = "sys-stats"
    container_port   = 80
  }
  network_configuration {
    subnets = aws_subnet.private.*.id
    #by default it's false
    assign_public_ip = false
    security_groups  = [aws_security_group.allow_ecs_80.id]
  }
}

resource "aws_ecs_service" "api-backend" {
  name            = "${var.default_tag.Project}-api-backend"
  cluster         = aws_ecs_cluster.red_acre.arn
  task_definition = aws_ecs_task_definition.api-backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.aws_tg-api-5000.arn
    container_name   = "api-backend"
    container_port   = 5000
  }
  network_configuration {
    subnets = aws_subnet.private.*.id
    #by default it's false
    assign_public_ip = false
    security_groups  = [aws_security_group.allow_http-api.id]
  }
}