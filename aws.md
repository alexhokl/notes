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

### EC2

-	Always create a IAM role with an EC2 instance.
