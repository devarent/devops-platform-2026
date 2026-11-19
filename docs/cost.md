# Cost Optimization Notes

This lab is designed to be understandable first and cheap second. The notes
below explain the main cost drivers and how to reduce them.

## Cost drivers

| Resource | Notes |
| --- | --- |
| NAT Gateway | Charged per hour plus per GB processed. Often the largest network cost. |
| EKS control plane | Fixed hourly charge per cluster. |
| EC2 worker nodes | Depends on instance type and count. |
| RDS | Charged for instance hours and storage; more for Multi-AZ. |
| ECR | Storage and data transfer out. |
| Load balancer | Hourly charge plus LCU usage. |

## Optimization ideas

1. **Single NAT gateway in non-production.** The VPC module defaults to one
   NAT gateway. Set `single_nat_gateway = false` only when you need
   high-availability egress.
2. **Right-size nodes.** Start with `t3.medium`. Use the HPA to scale pods
   before adding nodes. Consider Spot capacity for fault-tolerant workloads.
3. **Right-size RDS.** Use `db.t3.medium` for dev. Enable Multi-AZ only where
   the availability target requires it.
4. **Schedule non-production shutdown.** Stop dev/staging clusters and
   databases outside working hours.
5. **Set ECR lifecycle policies.** The ECR module keeps the last 10 tagged
   images. Tune this to control storage growth.
6. **Use Savings Plans or Reserved Instances** for stable production workloads.
7. **Tag everything.** The `default_tags` block in `terraform/main.tf` applies
   common tags so spend can be attributed per environment.

## Guardrails

- Set AWS Budgets alerts at 50%, 80%, and 100% of the monthly target.
- Enable Cost Anomaly Detection.
- Review the AWS Cost Explorer report monthly.

> These are estimates and examples. Always verify with the AWS Pricing
> Calculator for your region before making changes.
