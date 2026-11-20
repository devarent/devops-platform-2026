# Devops-Platform-2026
<sub><span style="opacity: 0.85">Production-style AWS platform lab: VPC/EKS/RDS via Terraform, Helm, GitHub Actions, Prometheus/Grafana, Trivy, SLOs and runbooks.</span></sub>
<div align="center" style="font-size: 0.9em">
<img src="assets/brand-logo.svg" alt="Arya Fatthurahman" width="130px" />
</div>

[![CI](https://github.com/devarent/devops-platform-2026/actions/workflows/ci.yml/badge.svg)](https://github.com/devarent/devops-platform-2026/actions/workflows/ci.yml)

---


<!-- identity-block -->
<div align="center">

# devops-platform-2026

<sub>Production-style AWS platform lab: VPC/EKS/RDS via Terraform, Helm, GitHub Actions, Prometheus/Grafana, Trivy, SLOs and runbooks.</sub>

</div>

## At a glance

| Field | Detail |
| --- | --- |
| Repository | devops-platform-2026 |
| Primary language | HCL |
| Topics | aws, devops, devsecops, eks, github-actions, grafana, helm, kubernetes, prometheus, terraform |
| License | MIT |
| Branch | main |
| Maintainer | [@devarent](https://github.com/devarent) |

## Overview

devops-platform-2026 is a hands-on repository focused on: Production-style AWS platform lab: VPC/EKS/RDS via Terraform, Helm, GitHub Actions, Prometheus/Grafana, Trivy, SLOs and runbooks.. Primary language: HCL. Topics: aws, devops, devsecops, eks, github-actions, grafana, helm, kubernetes, prometheus, terraform. The README below documents the project; use the table above for a quick overview.

### Global references

<div align="center">

🇮🇸 Iceland &middot; 🇳🇿 New Zealand &middot; 🇨🇭 Switzerland &middot; 🇸🇮 Slovenia &middot; 🇮🇪 Ireland &middot; 🇦🇹 Austria &middot; 🇵🇹 Portugal &middot; 🇸🇬 Singapore &middot; 🇫🇮 Finland

</div>

---

<!-- dbx-style-kit -->
<div align="center">

<img src="https://img.shields.io/badge/devops-platform-2026-1f6feb?style=for-the-badge" alt="devops-platform-2026" />
<img src="https://img.shields.io/badge/LANG%20HCL-3178c6?style=for-the-badge" alt="LANG HCL" />
<img src="https://img.shields.io/badge/STARS%200-eab308?style=for-the-badge" alt="STARS 0" />
<img src="https://img.shields.io/badge/LICENSE%20MIT-22c55e?style=for-the-badge" alt="LICENSE MIT" />

<br>

<img src="https://img.shields.io/badge/OPEN%20SOURCE-yes-22c55e?style=for-the-badge&logo=github&logoColor=white" alt="OPEN SOURCE" />
<img src="https://img.shields.io/badge/BUILT%20IN%20PUBLIC-true-6366f1?style=for-the-badge&logo=opensourceinitiative&logoColor=white" alt="BUILT IN PUBLIC" />
<img src="https://img.shields.io/badge/HANDS%20ON%20LABS-52-0ea5e9?style=for-the-badge&logo=docker&logoColor=white" alt="HANDS ON LABS" />
<img src="https://img.shields.io/badge/DOCUMENTED-yes-14b8a6?style=for-the-badge&logo=markdown&logoColor=white" alt="DOCUMENTED" />

<br>

<b>Production-style AWS platform lab: VPC/EKS/RDS via Terraform, Helm, GitHub Actions, Prometheus/Grafana, Trivy, SLOs and runbooks.</b>

</div>

---
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

---

<!-- tech-stack-wall -->
## Tech Stack

<div align="center">

<img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform" />
<img src="https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonwebservices&logoColor=white" alt="AWS" />
<img src="https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" alt="Kubernetes" />
<img src="https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white" alt="Prometheus" />
<img src="https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white" alt="Grafana" />
<img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker" />
<img src="https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white" alt="GitHub Actions" />

</div>

<details>
<summary><b>Full Tech Stack Wall</b></summary>
<br>

<div align="center">

<b>Languages</b><br>
<img src="https://img.shields.io/badge/Rust-dea584?style=for-the-badge&logo=rust&logoColor=black" alt="Rust" />
<img src="https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white" alt="Go" />
<img src="https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white" alt="TypeScript" />
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" alt="JavaScript" />
<img src="https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white" alt="Java" />
<img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python" />
<img src="https://img.shields.io/badge/C-A8B9CC?style=for-the-badge&logo=c&logoColor=black" alt="C" />
<img src="https://img.shields.io/badge/C%2B%2B-00599C?style=for-the-badge&logo=cplusplus&logoColor=white" alt="C++" />
<img src="https://img.shields.io/badge/Kotlin-7F52FF?style=for-the-badge&logo=kotlin&logoColor=white" alt="Kotlin" />
<img src="https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=swift&logoColor=white" alt="Swift" />
<img src="https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white" alt="Ruby" />
<img src="https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white" alt="PHP" />
<img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" alt="Lua" />
<img src="https://img.shields.io/badge/Shell-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white" alt="Shell" />
<br><br>
<b>Frontend &amp; Desktop</b><br>
<img src="https://img.shields.io/badge/Vue-4FC08D?style=for-the-badge&logo=vuedotjs&logoColor=black" alt="Vue" />
<img src="https://img.shields.io/badge/React-61DAFB?style=for-the-badge&logo=react&logoColor=black" alt="React" />
<img src="https://img.shields.io/badge/Svelte-FF3E00?style=for-the-badge&logo=svelte&logoColor=white" alt="Svelte" />
<img src="https://img.shields.io/badge/Next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white" alt="Next.js" />
<img src="https://img.shields.io/badge/Nuxt-00DC82?style=for-the-badge&logo=nuxtdotjs&logoColor=black" alt="Nuxt" />
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
<img src="https://img.shields.io/badge/React%20Native-61DAFB?style=for-the-badge&logo=react&logoColor=black" alt="React Native" />
<img src="https://img.shields.io/badge/Tauri-FFC131?style=for-the-badge&logo=tauri&logoColor=black" alt="Tauri" />
<img src="https://img.shields.io/badge/Electron-47848F?style=for-the-badge&logo=electron&logoColor=white" alt="Electron" />
<img src="https://img.shields.io/badge/Vite-646CFF?style=for-the-badge&logo=vite&logoColor=white" alt="Vite" />
<img src="https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white" alt="HTML5" />
<img src="https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white" alt="CSS3" />
<img src="https://img.shields.io/badge/Sass-CC6699?style=for-the-badge&logo=sass&logoColor=white" alt="Sass" />
<img src="https://img.shields.io/badge/Less-1D365D?style=for-the-badge&logo=less&logoColor=white" alt="Less" />
<img src="https://img.shields.io/badge/Tailwind%20CSS-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white" alt="Tailwind CSS" />
<img src="https://img.shields.io/badge/Bootstrap-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white" alt="Bootstrap" />
<img src="https://img.shields.io/badge/Three.js-000000?style=for-the-badge&logo=threedotjs&logoColor=white" alt="Three.js" />
<img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" alt="Node.js" />
<img src="https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white" alt="jQuery" />
<br><br>
<b>Database &amp; Storage</b><br>
<img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL" />
<img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
<img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" />
<img src="https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white" alt="SQL Server" />
<img src="https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white" alt="Oracle" />
<img src="https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white" alt="Redis" />
<img src="https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white" alt="MongoDB" />
<img src="https://img.shields.io/badge/DuckDB-FFCB00?style=for-the-badge&logo=duckdb&logoColor=black" alt="DuckDB" />
<img src="https://img.shields.io/badge/ClickHouse-FFCC00?style=for-the-badge&logo=clickhouse&logoColor=black" alt="ClickHouse" />
<img src="https://img.shields.io/badge/Elasticsearch-005571?style=for-the-badge&logo=elasticsearch&logoColor=white" alt="Elasticsearch" />
<img src="https://img.shields.io/badge/Neo4j-008CC1?style=for-the-badge&logo=neo4j&logoColor=white" alt="Neo4j" />
<img src="https://img.shields.io/badge/InfluxDB-22ADF6?style=for-the-badge&logo=influxdb&logoColor=white" alt="InfluxDB" />
<img src="https://img.shields.io/badge/Cassandra-1287B1?style=for-the-badge&logo=apachecassandra&logoColor=white" alt="Cassandra" />
<img src="https://img.shields.io/badge/DynamoDB-4053D6?style=for-the-badge&logo=amazondynamodb&logoColor=white" alt="DynamoDB" />
<img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
<img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=black" alt="Supabase" />
<img src="https://img.shields.io/badge/MinIO-C72E49?style=for-the-badge&logo=minio&logoColor=white" alt="MinIO" />
<img src="https://img.shields.io/badge/Firebird-FC521F?style=for-the-badge" alt="Firebird" />
<img src="https://img.shields.io/badge/IBM%20DB2-1F70C1?style=for-the-badge" alt="IBM DB2" />
<img src="https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white" alt="MariaDB" />
<img src="https://img.shields.io/badge/CockroachDB-7B52C0?style=for-the-badge" alt="CockroachDB" />
<img src="https://img.shields.io/badge/IRIS-3B82F6?style=for-the-badge" alt="IRIS" />
<img src="https://img.shields.io/badge/Databricks%20SQL-FF3621?style=for-the-badge&logo=databricks&logoColor=white" alt="Databricks SQL" />
<img src="https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white" alt="Snowflake" />
<img src="https://img.shields.io/badge/Qdrant-DC244C?style=for-the-badge" alt="Qdrant" />
<img src="https://img.shields.io/badge/Redshift-8C4FFF?style=for-the-badge&logo=amazonredshift&logoColor=white" alt="Redshift" />
<img src="https://img.shields.io/badge/Apache%20Kylin-F59E0B?style=for-the-badge" alt="Apache Kylin" />
<img src="https://img.shields.io/badge/BigQuery-4285F4?style=for-the-badge&logo=googlebigquery&logoColor=white" alt="BigQuery" />
<img src="https://img.shields.io/badge/VictoriaMetrics-3483EB?style=for-the-badge" alt="VictoriaMetrics" />
<img src="https://img.shields.io/badge/Databend-4F46E5?style=for-the-badge" alt="Databend" />
<img src="https://img.shields.io/badge/TDengine-1B8FD4?style=for-the-badge" alt="TDengine" />
<img src="https://img.shields.io/badge/Teradata-0055A6?style=for-the-badge" alt="Teradata" />
<br><br>
<b>Messaging &amp; Streaming</b><br>
<img src="https://img.shields.io/badge/Kafka-231F20?style=for-the-badge&logo=apachekafka&logoColor=white" alt="Kafka" />
<img src="https://img.shields.io/badge/RabbitMQ-FF6600?style=for-the-badge&logo=rabbitmq&logoColor=white" alt="RabbitMQ" />
<img src="https://img.shields.io/badge/RocketMQ-FF6A00?style=for-the-badge&logoColor=white" alt="RocketMQ" />
<img src="https://img.shields.io/badge/Pulsar-188FFF?style=for-the-badge&logo=apachepulsar&logoColor=white" alt="Pulsar" />
<img src="https://img.shields.io/badge/Flink-E6526F?style=for-the-badge&logo=apacheflink&logoColor=white" alt="Flink" />
<br><br>
<b>DevOps &amp; Cloud Native</b><br>
<img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker" />
<img src="https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" alt="Kubernetes" />
<img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform" />
<img src="https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white" alt="Ansible" />
<img src="https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white" alt="Jenkins" />
<img src="https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white" alt="GitHub Actions" />
<img src="https://img.shields.io/badge/GitLab%20CI-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white" alt="GitLab CI" />
<img src="https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white" alt="Prometheus" />
<img src="https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white" alt="Grafana" />
<img src="https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white" alt="Nginx" />
<img src="https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonwebservices&logoColor=white" alt="AWS" />
<img src="https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Azure" />
<img src="https://img.shields.io/badge/Cloudflare-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare" />
<br><br>
<b>Tools &amp; Platforms</b><br>
<img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white" alt="Git" />
<img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux" />
<img src="https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white" alt="macOS" />
<img src="https://img.shields.io/badge/VS%20Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white" alt="VS Code" />
<img src="https://img.shields.io/badge/Vim-019733?style=for-the-badge&logo=vim&logoColor=white" alt="Vim" />
<img src="https://img.shields.io/badge/Tmux-1BB91F?style=for-the-badge&logoColor=white" alt="Tmux" />
<img src="https://img.shields.io/badge/Homebrew-FAB316?style=for-the-badge&logo=homebrew&logoColor=black" alt="Homebrew" />
<img src="https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white" alt="Postman" />
<img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white" alt="Figma" />
<img src="https://img.shields.io/badge/Markdown-000000?style=for-the-badge&logo=markdown&logoColor=white" alt="Markdown" />
<img src="https://img.shields.io/badge/Maven-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white" alt="Maven" />
<img src="https://img.shields.io/badge/Gradle-02303A?style=for-the-badge&logo=gradle&logoColor=white" alt="Gradle" />
<img src="https://img.shields.io/badge/CMake-064F8C?style=for-the-badge&logo=cmake&logoColor=white" alt="CMake" />

</div>
</details>

<div align="center">
<sub>Hands-on engineering, built and documented in the open.</sub>
</div>