variable "role_name" {
  description = "Name of the IAM role."
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the cluster OIDC provider."
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL without https://."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace of the service account."
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes service account name."
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
