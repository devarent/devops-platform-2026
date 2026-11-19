variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name (dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name used to prefix resource names."
  type        = string
  default     = "devops-platform-2026"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for public and private subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.29"
}

variable "node_instance_types" {
  description = "Instance types for the EKS managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 4
}

variable "rds_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.medium"
}

variable "rds_allocated_storage" {
  description = "Allocated storage in GiB for RDS."
  type        = number
  default     = 20
}

variable "rds_database_name" {
  description = "Name of the default PostgreSQL database."
  type        = string
  default     = "platformdb"
}

variable "rds_username" {
  description = "Master username for RDS."
  type        = string
  default     = "platformadmin"
}

variable "rds_password" {
  description = "Master password for RDS. Supply via a secret manager at apply time."
  type        = string
  sensitive   = true
  default     = "REPLACE_ME"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository for the sample workload."
  type        = string
  default     = "platform-api"
}

variable "workload_namespace" {
  description = "Kubernetes namespace for IRSA and the sample workload."
  type        = string
  default     = "platform"
}

variable "workload_service_account" {
  description = "Kubernetes service account name used for IRSA."
  type        = string
  default     = "platform-api"
}

variable "tags" {
  description = "Common tags applied to taggable resources."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Project   = "devops-platform-2026"
  }
}
