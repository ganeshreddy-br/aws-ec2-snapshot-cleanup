output "scheduler_role_arn" {
  value = aws_iam_role.scheduler_role.arn
}

output "schedule_name" {
  value = aws_scheduler_schedule.snapshot_schedule.name
}