output "lambda_name" {
  value = module.snapshot_lambda.lambda_name
}

output "lambda_arn" {
  value = module.snapshot_lambda.lambda_arn
}

output "schedule_name" {
  value = module.scheduler.schedule_name
}