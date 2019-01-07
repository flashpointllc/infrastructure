# alb.tf

### ALB ###
resource "aws_security_group" "alb_sg" {
  depends_on  = ["module.network"]
  name        = "${var.environment}-alb-sg"
  description = "Allow HTTP/HTTPS traffic to load balancer"
  vpc_id      = "${module.network.vpc_id}"

  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_alb" "alb" {
  depends_on          = ["module.network", "aws_security_group.alb_sg"]
  name                = "${var.environment}-alb"
  security_groups     = ["${aws_security_group.alb_sg.id}"]
  subnets             = ["${module.network.public_subnet_ids}"]

  tags = {
    Environment = "${var.environment}"
  }
}
