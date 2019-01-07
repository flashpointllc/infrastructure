# vars.tf

variable "name" {
  description = "Name to be used on all the resources as identifier"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
}

variable "azs" {
  description = "A list of availability zoens in the region"
  type        = "list"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = "list"
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = "list"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

