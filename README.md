# DevOps Platform 2026

A production-style AWS platform reference implementation for a GitHub profile.
It provisions a secure multi-AZ network, an EKS cluster, a managed PostgreSQL
database, an image registry, and IAM roles with IRSA. It also ships a Helm
chart, hardening manifests, CI/CD pipelines, monitoring assets, runbooks, and
backup scripts.

Everything in this repository is illustrative. There are no real credentials,
account IDs, or secrets. All sensitive values use placeholders such as
`<ACCOUNT_ID>` and `REPLACE_ME`.

## Table of contents

- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Repository structure](#repository-structure)
- [Getting started](#getting-started)
- [CI/CD overview](#cicd-overview)
- [Monitoring](#monitoring)
- [Cost notes](#cost-notes)
- [Security notes](#security-notes)

## Architecture

The platform uses a VPC with public and private subnets across two
Availability Zones. Public subnets host the internet-facing load balancer and
NAT gateway. Private subnets host EKS worker nodes and the RDS database.

```mermaid
flowchart TD
    Internet[Internet] --> IGW[Internet Gateway]
    IGW --> ALB[Application Load Balancer\npublic subnets]
    ALB --> SVC[Kubernetes Service\nprivate subnets]
    SVC --> POD[App Pods\nEKS managed node group]
    NAT[NAT Gateway\npublic subnet] --> Egress[External services]
    POD --> NAT
    POD --> RDS[(RDS PostgreSQL\nprivate subnets)]
    POD --> ECR[ECR image registry]
    POD -. IRSA .-> IAM[IAM roles]\n[OIDC provider]
    Prometheus[Prometheus] --> Grafana[Grafana]
    Prometheus --> POD
```

ASCII equivalent:

```text
                       +-------------------+
 Internet ------------>|  Internet Gateway |
                       +---------+---------+
                                 |
                +----------------+-----------------+
                |  Public subnets (AZ-a, AZ-b)     |
                |  [ALB]            [NAT GW]        |
                +--------+---------------+---------+
                         |               |
                +--------v-------+       |  egress
                | Private subnets|       v
                |  [EKS nodes]---+---> Internet
                |  [RDS Postgres]|
                +----------------+
```

## Prerequisites

- Terraform `>= 1.5.0`
- AWS CLI `v2` with a named profile
- `kubectl` and `helm` `v3`
- An AWS account and a role that Terraform can assume via OIDC or static creds
- An S3 bucket and DynamoDB table for the Terraform remote backend (placeholders
  in `terraform/versions.tf`)
- A public hosted zone if you want the Ingress to create DNS records

## Repository structure

```text
devops-platform-2026/
|-- .github/workflows/       # CI and deploy pipelines
|   |-- ci.yml
|   `-- deploy.yml
|-- docs/                    # Runbooks and operational docs
|   |-- runbook.md
|   |-- slo.md
|   `-- cost.md
|-- helm/platform/           # Sample workload Helm chart
|   |-- Chart.yaml
|   |-- values.yaml
|   `-- templates/
|-- k8s/                     # Hardening and policy manifests
|   |-- namespace.yaml
|   |-- networkpolicy.yaml
|   `-- poddisruptionbudget.yaml
|-- monitoring/              # Alerts and dashboards
|   |-- prometheus-rules.yaml
|   `-- grafana-dashboard.json
|-- scripts/                 # Backup and restore helpers
|   |-- backup.sh
|   `-- restore.sh
|-- terraform/               # Root config and reusable modules
|   |-- main.tf
|   |-- variables.tf
|   |-- outputs.tf
|   |-- versions.tf
|   |-- terraform.tfvars.example
|   `-- modules/
|-- .gitignore
|-- LICENSE
`-- README.md
```

## Getting started

1. Copy the example variables file and fill in your values. Never commit the
   real `terraform.tfvars` file.

   ```sh
   cp terraform/terraform.tfvars.example terraform/terraform.tfvars
   ```

2. Update the backend block in `terraform/versions.tf` with your S3 bucket and
   DynamoDB table, then initialize.

   ```sh
   cd terraform
   terraform init
   ```

3. Review the plan before applying.

   ```sh
   terraform fmt -check -recursive
   terraform validate
   terraform plan -out=tfplan
   ```

4. Apply the plan.

   ```sh
   terraform apply tfplan
   ```

5. Configure kubectl against the new cluster.

   ```sh
   aws eks update-kubeconfig --name <CLUSTER_NAME> --region <AWS_REGION>
   kubectl apply -f ../k8s/
   helm upgrade --install platform ../helm/platform -n platform --create-namespace
   ```

To destroy everything, run `terraform destroy` after removing any resources
protected by deletion protection.

## CI/CD overview

- `.github/workflows/ci.yml` runs on pull requests and pushes. It checks
  Terraform formatting and validation, scans IaC with Trivy, and lints the Helm
  chart.
- `.github/workflows/deploy.yml` runs a plan on pull requests and an apply on
  pushes to `main`. It is designed for GitHub OIDC: the workflow requests a
  short-lived AWS role using `aws-actions/configure-aws-credentials@v4` and a
  `role-to-assume` placeholder. No long-lived access keys are stored.

Before enabling deploy, create an IAM role in AWS with a trust policy for
GitHub's OIDC provider and replace the `ROLE_TO_ASSUME` placeholder.

## Monitoring

- `monitoring/prometheus-rules.yaml` defines alerting rules for high CPU,
  memory pressure, pod restarts, and target downtime.
- `monitoring/grafana-dashboard.json` is a minimal dashboard showing cluster
  health signals. Import it into Grafana and point it at your Prometheus
  datasource.

The `docs/runbook.md` file links alerts to response steps, and `docs/slo.md`
defines service level objectives and error budgets.

## Cost notes

The largest cost drivers are the NAT gateway, EKS control plane, and RDS
instance. See `docs/cost.md` for optimization ideas such as single NAT gateway
in non-production, Spot node groups, and right-sizing.

## Security notes

- All workloads run as non-root with dropped capabilities and read-only root
  filesystems.
- Network policies restrict pod-to-pod traffic.
- IAM roles for service accounts (IRSA) scope AWS permissions to a single
  Kubernetes service account.
- Sensitive values belong in AWS Secrets Manager or Parameter Store, never in
  this repository.

## License

MIT. See `LICENSE`.
