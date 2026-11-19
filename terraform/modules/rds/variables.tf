variable "identifier" {
  description = "RDS instance identifier."
  type        = string
}

variable "database_name" {
  description = "Name of the initial database."
  type        = string
  default     = "platformdb"
}

variable "username" {
  description = "Master username."
  type        = string
  default     = "platformadmin"
}

variable "password" {
  description = "Master password. Supply via a secret manager at apply time."
  type        = string
  sensitive   = true
}

variable "engine" {
  description = "Database engine."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version."
  type        = string
  default     = "16.3"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Allocated storage in GiB."
  type        = number
  default     = 20
}

variable "subnet_ids" {
  description = "Private subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Security group IDs attached to the instance."
  type        = list(string)
}

variable "multi_az" {
  description = "Deploy across multiple availability zones."
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "Enable storage encryption."
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot on destroy. Set false in production."
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
