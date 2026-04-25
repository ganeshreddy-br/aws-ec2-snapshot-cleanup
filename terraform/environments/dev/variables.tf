variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "retention_days" {
  description = "Snapshot retention period in days"
  type        = string
}

variable "schedule_expression" {
  description = "EventBridge schedule expression (rate)"
  type        = string
}