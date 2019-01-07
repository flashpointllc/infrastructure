[
  {
    "name": "${app_name}",
    "image": "${repo_url}",
    "cpu": ${cpu},
    "memory": ${memory},
    "essential": true,
    "compatibilities": [
      "FARGATE"
    ],
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${host_port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${logs_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
