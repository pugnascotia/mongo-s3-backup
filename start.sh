#!/bin/bash

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
CRON_ENVIRONMENT="
HOME=/root
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?"env variable is required"}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?"env variable is required"}
MONGO_HOST=${MONGO_HOST:?"env variable is required"}
MONGO_PORT=${MONGO_PORT:?"env variable is required"}
MONGO_DB=${MONGO_DB}
MONGO_USER=${MONGO_USER}
MONGO_PASSWORD=${MONGO_PASSWORD}
S3_BUCKET=${S3_BUCKET:?"env variable is required"}
BACKUP_FILENAME_DATE_FORMAT=${BACKUP_FILENAME_DATE_FORMAT:-%Y%m%d}
BACKUP_FILENAME_PREFIX=${BACKUP_FILENAME_PREFIX:-mongo_backup}
"
CRON_COMMAND="/script/backup.sh 1>/var/log/backup_script.log 2>&1"

cat >/root/.s3cfg <<END
access_key = $AWS_ACCESS_KEY_ID
secret_key = $AWS_SECRET_ACCESS_KEY
END

echo
echo "Configuration"
echo
echo "CRON_SCHEDULE"
echo
echo "$CRON_SCHEDULE"
echo
echo "CRON_ENVIRONMENT"
echo "$CRON_ENVIRONMENT"

echo "$CRON_ENVIRONMENT$CRON_SCHEDULE $CRON_COMMAND" | crontab -
mkfifo /var/log/backup_script.log
cron
tail -f /var/log/backup_script.log
