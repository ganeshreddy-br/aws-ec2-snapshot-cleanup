provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Application = "ec2-snapshot-cleanup"
      Environment = var.environment
    }
  }
}