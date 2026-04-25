variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "CIDR blocks for two private subnets"
  type        = list(string)

  validation {
    condition     = length(var.subnet_cidrs) == 2
    error_message = "Exactly 2 subnet CIDRs must be provided."
  }
}

variable "retention_days" {
  description = "Snapshot retention period in days"
  type        = string
}

variable "schedule_expression" {
  description = "EventBridge Scheduler expression"
  type        = string
}