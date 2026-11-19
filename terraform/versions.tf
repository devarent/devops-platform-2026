terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Replace the placeholders below with your own backend bucket/table.
  backend "s3" {
    bucket         = "REPLACE_ME_TF_STATE_BUCKET"
    key            = "devops-platform-2026/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "REPLACE_ME_TF_LOCK_TABLE"
    encrypt        = true
  }
}
