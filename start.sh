#!/bin/bash

cat >/root/.s3cfg <<END
access_key = $AWS_ACCESS_KEY_ID
secret_key = $AWS_SECRET_ACCESS_KEY
END

CRON_BACKUP_SCRIPT=/root/mongo-backup.sh
CRON_COMMAND="/script/backup.sh 1>/var/log/backup_script.log 2>&1"

cat >$CRON_BACKUP_SCRIPT <<END
#!/bin/sh
export HOME=/root
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?"env variable is required"}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?"env variable is required"}
export MONGO_HOST=${MONGO_HOST:?"env variable is required"}
export MONGO_PORT=${MONGO_PORT:?"env variable is required"}
export MONGO_DB=${MONGO_DB}
export MONGO_USER=${MONGO_USER}
export MONGO_PASSWORD=${MONGO_PASSWORD}
export S3_BUCKET=${S3_BUCKET:?"env variable is required"}
export BACKUP_FILENAME_DATE_FORMAT=${BACKUP_FILENAME_DATE_FORMAT:-%Y%m%d}
export BACKUP_FILENAME_PREFIX=${BACKUP_FILENAME_PREFIX:-mongo_backup}

/script/backup.sh 1>/var/log/backup_script.log 2>&1
END

chmod a+x $CRON_BACKUP_SCRIPT

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
echo "$CRON_SCHEDULE $CRON_BACKUP_SCRIPT" | crontab -
mkfifo /var/log/backup_script.log
cron
echo "cron task started: $CRON_SCHEDULE $CRON_BACKUP_SCRIPT"
tail -f /var/log/backup_script.log

