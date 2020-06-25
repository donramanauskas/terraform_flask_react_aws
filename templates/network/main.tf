resource "aws_vpc" "flask_react_demo_vpc" {
  cidr_block       = var.flask_react_demo_cidr
  instance_tenancy = var.vpc_tenancy

  tags = {
    Name = "${var.vpc_name}-${var.environment}"
  }
}

resource "aws_subnet" "flask_react_demo_public" {
  count             = length(var.public_subnets) > 0 ? 2 : 0
  cidr_block        = var.public_subnets[count.index]
  vpc_id            = aws_vpc.flask_react_demo_vpc.id
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "public-${var.vpc_name}-${var.environment}-${var.availability_zones[count.index]}"
  }

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.flask_react_demo_vpc.id

  tags = {
    Name = "flask_react_demo_app_gw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.flask_react_demo_vpc.id

  tags = {
    "Name" = "flask-react-demo-public-RT"
  }
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_lb" "flask_react_demo_lb" {

  name               = "flask-react-demo-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.flask_react_demo_public.*.id
}

resource "aws_lb_target_group" "flask_react_client_tg" {
  name = "flask-react-client-tg"
  port = 80
  target_type = "instance"
  protocol = "HTTP"
  vpc_id = aws_vpc.flask_react_demo_vpc.id
}

resource "aws_lb_target_group" "flask_react_users_tg" {
  name = "flask-react-users-tg"
  port = 80
  target_type = "instance"
  protocol = "HTTP"
  vpc_id = aws_vpc.flask_react_demo_vpc.id
}

resource "aws_lb_listener" "flask_react_demo_listener" {

  load_balancer_arn = aws_lb.flask_react_demo_lb.arn
  port = 80
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.flask_react_client_tg.arn
  }

}

resource "aws_lb_listener_rule" "forward_to_users" {
  listener_arn = aws_lb_listener.flask_react_demo_listener.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.flask_react_users_tg.arn
  }

  condition {
    path_pattern {
      values = ["/users*", "/ping", "/auth*", "/doc/", "/swagger*"]
    }
  }

}