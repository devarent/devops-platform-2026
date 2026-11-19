#!/usr/bin/env bash
# Backup the platform PostgreSQL database to an S3 bucket.
# Replace every REPLACE_ME placeholder before use.
set -euo pipefail

DB_ENDPOINT="${DB_ENDPOINT:-REPLACE_ME_RDS_ENDPOINT}"
DB_NAME="${DB_NAME:-platformdb}"
DB_USER="${DB_USER:-platformadmin}"
BACKUP_BUCKET="${BACKUP_BUCKET:-REPLACE_ME_BACKUP_BUCKET}"
AWS_REGION="${AWS_REGION:-us-east-1}"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
FILE_NAME="${DB_NAME}-${TIMESTAMP}.sql.gz"
LOCAL_FILE="/tmp/${FILE_NAME}"

echo "Starting backup of ${DB_NAME} from ${DB_ENDPOINT}"

# The password is supplied by the environment or a secret manager. Never hardcode it.
: "${DB_PASSWORD:?Set DB_PASSWORD before running this script}"

pg_dump \
  --host="${DB_ENDPOINT}" \
  --port=5432 \
  --username="${DB_USER}" \
  --format=custom \
  --no-owner \
  --no-privileges \
  "${DB_NAME}" | gzip > "${LOCAL_FILE}"

aws s3 cp "${LOCAL_FILE}" \
  "s3://${BACKUP_BUCKET}/postgres/${FILE_NAME}" \
  --region "${AWS_REGION}"

rm -f "${LOCAL_FILE}"

echo "Backup complete: s3://${BACKUP_BUCKET}/postgres/${FILE_NAME}"
