resource "aws_ecs_cluster" "flask_react_demo_cluster" {
  name = "flask_react_demo_cluster"
}

resource "aws_ecs_service" "users_service" {
  name = "users_service"
  task_definition = ""
}

resource "aws_ecs_task_definition" "users_service_td" {
  container_definitions = ""
  family = ""
}