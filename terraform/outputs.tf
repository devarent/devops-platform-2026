output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.vpc.private_subnet_ids
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster."
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

output "eks_cluster_ca_certificate" {
  description = "CA certificate of the EKS cluster."
  value       = module.eks.cluster_ca_certificate
  sensitive   = true
}

output "eks_oidc_provider_arn" {
  description = "ARN of the OIDC provider used for IRSA."
  value       = module.eks.oidc_provider_arn
}

output "eks_oidc_provider_url" {
  description = "URL of the OIDC provider used for IRSA."
  value       = module.eks.oidc_provider_url
}

output "irsa_role_arn" {
  description = "ARN of the IAM role bound to the workload service account."
  value       = module.iam.workload_role_arn
}

output "ecr_repository_url" {
  description = "URL of the ECR repository."
  value       = module.ecr.repository_url
}

output "rds_endpoint" {
  description = "Endpoint of the RDS PostgreSQL instance."
  value       = module.rds.db_instance_endpoint
  sensitive   = true
}

output "rds_identifier" {
  description = "Identifier of the RDS instance."
  value       = module.rds.db_instance_identifier
}
