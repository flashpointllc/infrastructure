# vars.tf

variable "name" {
  default = ""
}

variable "container_cpu" {
  default = 256
}

variable "container_memory" {
  default = 512
}

variable "num_of_image_backups" {
  description = "Number of backups of the container image to keep in ECR"
  default = "3"
}

variable "environment" {
  default = ""
}

variable "region" {
  default = ""
}

variable "port" {
  default = ""
}

variable "target_group_id" {
  default = ""
}

variable "cluster_id" {
  default = ""
}

variable "subnets" {
  default = []
}

variable "desired_count" {
}

variable "alb_sg_id" {
}

variable "vpc_id" {
}
