output "lambda_name" {
  value = module.snapshot_lambda.lambda_name
}

output "lambda_arn" {
  value = module.snapshot_lambda.lambda_arn
}

output "schedule_name" {
  value = module.scheduler.schedule_name
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "private_subnet_ids" {
  value = module.networking.subnet_ids
}