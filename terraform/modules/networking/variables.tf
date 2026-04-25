variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "CIDR blocks for private subnets (must be 2)"
  type        = list(string)

  validation {
    condition     = length(var.subnet_cidrs) == 2
    error_message = "Exactly 2 subnet CIDRs must be provided."
  }
}