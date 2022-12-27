output "role-arn" {
  value = aws_iam_role.master.arn
}

output "worker-role-arn" {
  value = aws_iam_role.workernodes.arn
}