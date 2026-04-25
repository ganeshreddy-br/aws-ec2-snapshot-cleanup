module "networking" {
  source = "../../modules/networking"

  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
}

module "lambda_package" {
  source = "../../modules/packaging"

  lambda_source_path = "${path.root}/../../../lambda"
}

module "snapshot_lambda" {
  source = "../../modules/lambda"

  function_name   = "snapshot-cleanup-prod"

  zip_path = module.lambda_package.zip_path
  zip_hash = module.lambda_package.zip_hash

  use_vpc = true

  subnet_ids         = module.networking.subnet_ids
  security_group_ids = [module.networking.lambda_sg_id]

  environment_variables = {
    RETENTION_DAYS  = var.retention_days
  }
}

module "scheduler" {
  source = "../../modules/scheduler"

  schedule_name       = "snapshot-cleanup-schedule-prod"
  lambda_arn          = module.snapshot_lambda.lambda_arn
  schedule_expression = var.schedule_expression
}
