# vpc.tf

### VPC ###
module "network" {
  source = "../../modules/network"
  
  name            = "${var.environment}-vpc"
  cidr            = "${var.vpc_cidr_block}"
  azs             = "${var.azs}"
  public_subnets  = "${var.public_subnets}"
  private_subnets = "${var.private_subnets}"

  tags = {
    Environment = "${var.environment}"
  }
}
