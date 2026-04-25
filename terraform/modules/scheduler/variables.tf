variable "schedule_name" {
  description = "Name of the schedule"
  type        = string
}

variable "lambda_arn" {
  description = "Lambda ARN to invoke"
  type        = string
}

variable "schedule_expression" {
  description = "Schedule expression (rate or cron)"
  type        = string
}