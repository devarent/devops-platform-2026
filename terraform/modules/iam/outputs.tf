output "workload_role_arn" {
  description = "ARN of the workload IAM role."
  value       = aws_iam_role.workload.arn
}

output "workload_role_name" {
  description = "Name of the workload IAM role."
  value       = aws_iam_role.workload.name
}
