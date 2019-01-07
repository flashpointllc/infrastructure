# main.tf

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v1.44.0"

  name    = "${var.name}"
  cidr    = "${var.cidr}"
  
  azs             = ["${var.azs}"]
  public_subnets  = ["${var.public_subnets}"]
  private_subnets = ["${var.private_subnets}"]

  tags = "${var.tags}"
}
