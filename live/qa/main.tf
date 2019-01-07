

provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "flashpoint-infrastructure"
    key    = "terraform/state/qa"
    region = "us-east-1"
  }
}
