# Mongo S3 Backup

This container runs a cron job which:

- dumps a mongo database using `mongodump`
- archives the dump and uploads it to Amazon S3

You can configure the execution of the above steps by setting the following
environment variables:

* `MONGO_HOST`
* `MONGO_PORT`
* `MONGO_USER`, optional
* `MONGO_PASSWORD`, optional
* `MONGO_DB`, optional
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `S3_BUCKET`
* `BACKUP_FILENAME_PREFIX`, optional, defaults to `mongo_backup`
* `BACKUP_FILENAME_DATE_FORMAT`, optional, defaults to `%Y%m%d`
* `CRON_SCHEDULE`, optional, defaults to `0 1 * * *`


### Usage:
```
# put your variables to the env file or pass them via --env option
docker run -d --env-file /opt/mongo-backup-env.lst --name mongo-backup kisel/mongo-s3-backup
```

