# main.tf

# 1.  create ecs task security group
# 2.  create load balancer target group
# 3.  create load balancer listener rule
# 4.  create ecr repo w. template app
# 5.  create ecs task definition
# 6.  create ecs task service
# 7.  setup cloud logging



## 1.  create ecs task security group
## 4.  create ecr repo w. template app
## 5.  create ecs task definition
## 6.  create ecs task service
## 7.  setup cloud logging

#########
## ECR ##
#########
resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.name}"
}

resource "aws_ecr_lifecycle_policy" "backup_policy" {
  repository = "${aws_ecr_repository.ecr_repo.name}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last ${var.num_of_image_backups} images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.num_of_image_backups}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "ecs_app_server_role_doc" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  },
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ecs.application-autoscaling.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_server_role" {
  name               = "${var.name}-server-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_app_server_role_doc.json}"
}

## Attach TaskExecution Policy to Server Role
resource "aws_iam_role_policy_attachment" "attach_ecs_task_policy" {
    depends_on      = ["aws_iam_role.ecs_server_role"]
    role            = "${aws_iam_role.ecs_server_role.name}"
    policy_arn      = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

##################
## ECS Task Def ##
##################
data "template_file" "task" {
  template = "${file("${path.module}/templates/service.tpl")}"

  vars {
    app_name          = "${var.name}"
    environment       = "${var.environment}"
    region            = "${var.region}"
    repo_url          = "${aws_ecr_repository.ecr_repo.repository_url}"
    cpu               = "${var.container_cpu}"
    memory            = "${var.container_memory}"
    container_port    = "${var.port}"
    host_port         = "${var.port}"
    logs_group        = "/${var.environment}/ecs/${var.name}"
  }
}

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "${var.name}"
  container_definitions    = "${data.template_file.task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "${var.container_cpu}"
  memory                   = "${var.container_memory}"
  execution_role_arn       = "${aws_iam_role.ecs_server_role.arn}"
  task_role_arn            = "${aws_iam_role.ecs_server_role.arn}"
}

#################
## ECS Service ##
#################
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name}-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = "${var.vpc_id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.port}"
    to_port         = "${var.port}"
    security_groups = ["${var.alb_sg_id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "main" {
  name                = "${var.name}"
  cluster             = "${var.cluster_id}"
  task_definition     = "${aws_ecs_task_definition.ecs_task_def.arn}"
  desired_count       = "${var.desired_count}"
  launch_type         = "FARGATE"

  network_configuration {
    security_groups   = ["${aws_security_group.ecs_tasks.id}"]
    subnets           = ["${var.subnets}"]
    assign_public_ip  = true
  }

  load_balancer {
    target_group_arn = "${var.target_group_id}"
    container_name   = "${var.name}"
    container_port   = "${var.port}"
  }
}

