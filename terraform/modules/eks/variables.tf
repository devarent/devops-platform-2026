variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version."
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "ID of the VPC."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the control plane and nodes."
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Security group for the cluster control plane."
  type        = string
}

variable "node_security_group_id" {
  description = "Security group for worker nodes."
  type        = string
}

variable "node_instance_types" {
  description = "Instance types for the node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired node count."
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum node count."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum node count."
  type        = number
  default     = 4
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
