# clucster.tf - Create ecs cluster

resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-ecs-cluster"

  tags = {
    Environment = "${var.environment}"
  }
}
