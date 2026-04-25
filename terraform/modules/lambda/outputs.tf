output "lambda_arn" {
  value = aws_lambda_function.snapshot_lambda.arn
}

output "lambda_name" {
  value = aws_lambda_function.snapshot_lambda.function_name
}