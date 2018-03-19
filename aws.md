### RDS

##### References

[Importing and Exporting SQL Server Databases](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/SQLServer.Procedural.Importing.html)

###### Enabling backup compression

```sql
exec rdsadmin..rds_set_configuration 'S3 backup compression', 'true';
```

###### Backup creation

```sql
exec msdb.dbo.rds_backup_database
	@source_db_name='MyDatabaseName',
	@s3_arn_to_backup_to='arn:aws:s3:::my_bucket_name/my_backup_name.bak',
	@overwrite_S3_backup_file=1;
```

###### Checking backup status

```sql
exec msdb.dbo.rds_task_status @db_name='MyDatabaseName'
```

###### Backup download from S3

```console
aws s3 cp s3://my_bucket_name/my_backup_name.bak my_backup_name.bak
```

###### Backup upload to S3

```console
aws s3 cp my_backup_name.bak s3://my_bucket_name/my_backup_name.bak
```

###### Restoring a backup

```sql
exec msdb.dbo.rds_restore_database
	@restore_db_name='MyDatabaseName',
	@s3_arn_to_restore_from='arn:aws:s3:::my_bucket_name/my_backup_name.bak';
```

### Lambda

#### .NET Core

###### Installing .NET Lambda Templates

```sh
dotnet new -i Amazon.Lambda.Templates::*
```

### SNS

#### Message size and format

- message size limit is 256KB
- message sizes between 64KB and 256KB must use AWS Signature Version 4 (SigV4) signing (see [ref](https://docs.aws.amazon.com/sns/latest/dg/large-payload-raw-message.html))
- message delivers to SQS or HTTP/S endpoints could be in raw instead of JSON (see [ref](https://docs.aws.amazon.com/sns/latest/dg/large-payload-raw-message.html))

### SQS

#### Message size and format

- message size limit is 256KB (unless Java library is used)
- message can be in JSON, XML and unformatted text

### EC2

-	Always create a IAM role with an EC2 instance.
