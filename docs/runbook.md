# Runbook

Operational procedures for the devops-platform-2026 lab. Replace placeholders
with your own cluster, region, and account details.

## Access

```sh
export AWS_REGION=<AWS_REGION>
aws eks update-kubeconfig --name <CLUSTER_NAME> --region "$AWS_REGION"
kubectl get nodes
kubectl get pods -n platform
```

## Incident response

1. **Acknowledge** the alert in your alerting tool and note the time.
2. **Assess** impact using the dashboard and alerts in `monitoring/`.
3. **Mitigate** using the steps below.
4. **Communicate** status to stakeholders.
5. **Resolve** and record the root cause.

### HighCPUUsage / HighMemoryUsage

- Check node utilization: `kubectl top nodes` and `kubectl top pods -n platform`.
- Identify a hot pod: `kubectl get pods -n platform --sort-by=.status.containerStatuses[0].restartCount`.
- If caused by a bad deploy, roll back: `kubectl rollout undo deployment/platform -n platform`.
- If capacity-bound, allow the HPA to scale or add nodes by raising `node_max_size`.

### PodRestartLoop / CrashLoopBackOff

- Describe the pod: `kubectl describe pod <POD> -n platform`.
- Read logs: `kubectl logs <POD> -n platform --previous`.
- Common causes: bad config, missing secret, failed readiness probe, OOMKilled.
- Verify resources and probes in `helm/platform/values.yaml`.

### TargetDown

- Confirm the Service endpoints: `kubectl get endpoints -n platform`.
- Check Ingress and security group rules.
- Verify the ALB health check path matches the liveness probe path.

### RDSHighConnections

- Inspect active connections in the database console.
- Restart the application to recycle stale pools: `kubectl rollout restart deployment/platform -n platform`.
- Consider a larger `rds_instance_class` if the load is legitimate.

## Common operations

### Deploy the workload

```sh
helm upgrade --install platform helm/platform -n platform --create-namespace
```

### Roll back a release

```sh
helm history platform -n platform
helm rollback platform <REVISION> -n platform
```

### Rotate the RDS password

1. Update the secret in your secret manager.
2. Set `TF_VAR_rds_password` from the secret and run `terraform apply`.
3. Restart workloads that hold database connections.

### Backup and restore

Use `scripts/backup.sh` and `scripts/restore.sh`. Verify backups with a
restore drill at least once per quarter.

## Escalation

If the platform cannot be recovered within 30 minutes, escalate to the cloud
platform owner and consider failing over to the standby region (if configured).
