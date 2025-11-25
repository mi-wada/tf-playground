# Managed by ecspresso
# resource "aws_ecs_service" "httpbin" {
#   name            = "httpbin-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.httpbin.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets         = [for s in aws_subnet.private : s.id]
#     security_groups = [aws_security_group.httpbin.id]
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.httpbin.arn
#     container_name   = "httpbin"
#     container_port   = 80
#   }

#   depends_on = [aws_lb_listener.http]
# }

resource "aws_security_group" "httpbin" {
  vpc_id = aws_vpc.main.id
  name   = "httpbin"
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_trafic_http" {
  description                  = "HTTP from ALB"
  security_group_id            = aws_security_group.httpbin.id
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.httpbin.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
