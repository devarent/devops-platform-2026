# Service Level Objectives

These SLOs are illustrative targets for the sample workload. Adjust them to
match your own user expectations.

## Service level indicators

- **Availability**: ratio of successful HTTP requests to total requests.
- **Latency**: proportion of requests served faster than a threshold.
- **Durability**: successful database backups.

## Targets

| SLI | Target | Window |
| --- | --- | --- |
| Availability | 99.9% successful requests | 30-day rolling |
| Latency (p95) | < 300 ms | 30-day rolling |
| Latency (p99) | < 1000 ms | 30-day rolling |
| Backup success | 100% of nightly backups | 30 days |

## Error budget

For a 99.9% availability target over 30 days:

- Total minutes in 30 days = 43,200.
- Allowed downtime = 0.1% = 43.2 minutes per 30 days.

Burn rate guidance:

- Burn rate > 14.4 (fast burn): page immediately; a 1-hour window at this
  rate consumes about 2% of the monthly budget.
- Burn rate > 6 (slow burn): open a ticket during business hours.
- Budget remaining < 25%: freeze risky changes and prioritize reliability.

## Measurement

Query the monthly availability SLI from Prometheus:

```promql
sum(rate(http_requests_total{job="platform-api",status!~"5.."}[30d]))
/
sum(rate(http_requests_total{job="platform-api"}[30d]))
```

Track the result on the Grafana dashboard in `monitoring/grafana-dashboard.json`.

## Review cadence

Review SLO performance monthly and after every Sev-1 incident. Update targets
only with explicit stakeholder agreement.
