# gateway.tf

# resource "aws_alb_target_group" "gateway_tg" {
#   name          = "${var.environment}-gateway-taget-group"
#   port          = "80"
#   protocol      = "HTTP"
#   vpc_id        = "${module.network.vpc_id}"
#   target_type   = "ip"

#   health_check {
#     healthy_threshold   = "3"
#     interval            = "30"
#     protocol            = "HTTP"
#     matcher             = "200"
#     timeout             = "3"
#     path                = "${var.health_check_path}"
#     unhealthy_threshold = "2"
#   }
# }

# resource "aws_alb_listener" "gateway_listener" {
#   load_balancer_arn = "${aws_alb.alb.id}"
#   port              = "80"
#   protocol          = "HTTP"
  
#   default_action {
#     target_group_arn = "${aws_alb_target_group.gateway_tg.id}"
#     type             = "forward"
#   }
# }

# module "gateway-ecs" {
#   source     = "../../modules/ecs"

#   name            = "qa-gateway"
#   environment     = "${var.environment}"
#   region          = "${var.region}"
#   port            = "80"
#   target_group_id = "${aws_alb_target_group.gateway_tg.id}"
#   cluster_id      = "${aws_ecs_cluster.cluster.id}"
#   subnets         = "${module.network.public_subnet_ids}"
#   desired_count   = 1
#   alb_sg_id       = "${aws_security_group.alb_sg.id}"
#   vpc_id          = "${module.network.vpc_id}"
# }
