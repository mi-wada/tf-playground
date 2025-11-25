# Managed by ecspresso
# resource "aws_ecs_task_definition" "httpbin" {
#   family                   = "httpbin"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256"
#   memory                   = "512"
#   execution_role_arn       = aws_iam_role.ecs_task_execution.arn
#   task_role_arn            = aws_iam_role.ecs_task.arn

#   container_definitions = jsonencode([
#     {
#       name      = "httpbin"
#       image     = "kennethreitz/httpbin:latest"
#       essential = true

#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#           protocol      = "tcp"
#         }
#       ]

#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           "awslogs-group"         = aws_cloudwatch_log_group.httpbin.name
#           "awslogs-region"        = "ap-northeast-1"
#           "awslogs-stream-prefix" = "httpbin"
#         }
#       }

#       environment = [
#         {
#           name  = "GUNICORN_CMD_ARGS"
#           value = "--bind=0.0.0.0:80"
#         }
#       ]
#     }
#   ])
# }

resource "aws_cloudwatch_log_group" "httpbin" {
  name              = "/ecs/httpbin"
  retention_in_days = 7
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
