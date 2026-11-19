variable "name_prefix" {
  description = "Name prefix for security groups."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block of the VPC, used as the internal traffic source."
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
