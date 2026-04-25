aws_region          = "eu-central-1"
environment         = "prod"

vpc_cidr = "10.0.0.0/24"

subnet_cidrs = [
  "10.0.0.0/28",
  "10.0.0.16/28"
]

retention_days      = "365"
schedule_expression = "rate(1 day)"