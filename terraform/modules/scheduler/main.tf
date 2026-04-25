resource "aws_iam_role" "scheduler_role" {
  name = "${var.schedule_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  tags = {
    Name = "${var.schedule_name}-role"
  }
}

resource "aws_iam_role_policy" "scheduler_policy" {
  name = "${var.schedule_name}-policy"
  role = aws_iam_role.scheduler_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "lambda:InvokeFunction"
      Resource = var.lambda_arn
    }]
  })
}

resource "aws_scheduler_schedule" "snapshot_schedule" {
  name        = var.schedule_name
  description = "Scheduled Lambda to clean up EC2 snapshots"
  group_name  = "default"

  schedule_expression = var.schedule_expression

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.lambda_arn
    role_arn = aws_iam_role.scheduler_role.arn
  }
}