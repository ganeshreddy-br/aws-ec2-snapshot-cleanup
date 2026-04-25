variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "zip_path" {
  description = "Path to Lambda zip file"
  type        = string
}

variable "zip_hash" {
  description = "Base64 SHA256 hash of zip"
  type        = string
}

variable "use_vpc" {
  description = "Whether Lambda runs in VPC"
  type        = bool
}

variable "subnet_ids" {
  description = "Subnet IDs for Lambda VPC config"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security groups for Lambda"
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Environment variables for Lambda"
  type        = map(string)
}