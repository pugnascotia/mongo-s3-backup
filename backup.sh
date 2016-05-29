#!/bin/bash

# Utility function
get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

OUT=$BACKUP_FILENAME_PREFIX-$(date +$BACKUP_FILENAME_DATE_FORMAT).tgz

# Script

echo "$(get_date) Mongo backup started"

echo "$(get_date) [Step 1/3] Running mongodump"
params=""
[ -z "$MONGO_USER" ] || params="$params --username $MONGO_USER"
[ -z "$MONGO_PASSWORD" ] || params="$params -password $MONGO_PASSWORD"
[ -z "$MONGO_DB" ] || params="$params --db $MONGO_DB"

mongodump --quiet --host $MONGO_HOST -port $MONGO_PORT $params

echo "$(get_date) [Step 2/3] Creating tar archive"
tar -zcvf $OUT dump/
rm -rf dump/

echo "$(get_date) [Step 3/3] Uploading archive to S3"
/usr/local/bin/aws s3 cp $OUT s3://$S3_BUCKET/
rm $OUT

echo "$(get_date) Mongo backup completed successfully"
