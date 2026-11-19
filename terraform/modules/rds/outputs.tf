output "db_instance_identifier" {
  description = "RDS instance identifier."
  value       = aws_db_instance.this.identifier
}

output "db_instance_endpoint" {
  description = "Connection endpoint of the RDS instance."
  value       = aws_db_instance.this.endpoint
  sensitive   = true
}

output "db_instance_arn" {
  description = "ARN of the RDS instance."
  value       = aws_db_instance.this.arn
}

output "db_name" {
  description = "Name of the default database."
  value       = aws_db_instance.this.db_name
}

output "db_port" {
  description = "Port of the RDS instance."
  value       = aws_db_instance.this.port
}
