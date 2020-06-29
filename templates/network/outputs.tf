output "vpc_id" {
  value = aws_vpc.flask_react_demo_vpc.id
}

output "vpc_arn" {
  value = aws_vpc.flask_react_demo_vpc.arn
}

output "subnets" {
  value = aws_subnet.flask_react_demo_public.*.id
}

output "load_balancer_dns_name" {
  value = aws_lb.flask_react_demo_lb.dns_name
}