#!/usr/bin/env bash
# Restore a platform PostgreSQL backup from S3.
# Replace every REPLACE_ME placeholder before use.
set -euo pipefail

DB_ENDPOINT="${DB_ENDPOINT:-REPLACE_ME_RDS_ENDPOINT}"
DB_NAME="${DB_NAME:-platformdb}"
DB_USER="${DB_USER:-platformadmin}"
BACKUP_BUCKET="${BACKUP_BUCKET:-REPLACE_ME_BACKUP_BUCKET}"
AWS_REGION="${AWS_REGION:-us-east-1}"

# Usage: ./restore.sh s3://bucket/postgres/db-20260101-120000.sql.gz
BACKUP_URI="${1:?Usage: restore.sh <s3-uri-of-backup>}"

LOCAL_FILE="/tmp/restore-$(date +%Y%m%d-%H%M%S).sql.gz"

echo "Downloading ${BACKUP_URI}"
aws s3 cp "${BACKUP_URI}" "${LOCAL_FILE}" --region "${AWS_REGION}"

: "${DB_PASSWORD:?Set DB_PASSWORD before running this script}"

echo "WARNING: this overwrites data in ${DB_NAME} on ${DB_ENDPOINT}."
read -r -p "Type YES to continue: " CONFIRM
if [ "${CONFIRM}" != "YES" ]; then
  echo "Aborted."
  rm -f "${LOCAL_FILE}"
  exit 1
fi

gunzip -c "${LOCAL_FILE}" | pg_restore \
  --host="${DB_ENDPOINT}" \
  --port=5432 \
  --username="${DB_USER}" \
  --dbname="${DB_NAME}" \
  --clean \
  --if-exists \
  --no-owner \
  --no-privileges

rm -f "${LOCAL_FILE}"

echo "Restore complete."
