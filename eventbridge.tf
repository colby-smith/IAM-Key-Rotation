resource "aws_scheduler_schedule" "key_rotation" {
  name                = "key-rotation-schedule"
  schedule_expression  = "cron(0 10 1 * ? *)"
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.key_rotation.arn
    role_arn = aws_iam_role.eventbridge.arn
  }
}
