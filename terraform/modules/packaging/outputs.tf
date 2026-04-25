output "zip_path" {
  value = data.archive_file.lambda_zip.output_path
}

output "zip_hash" {
  value = data.archive_file.lambda_zip.output_base64sha256
}