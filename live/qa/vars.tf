# vars.tf

variable "environment" {
  default = "qa"
}

variable "region" {
  default = "us-east-1"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

#########
## VPC ##
#########
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]  
}

variable "private_subnets" {
  default = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]  
}

variable "health_check_path" {
  default = "/health-check"
}
