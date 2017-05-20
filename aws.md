##### Setting up Docker on AWS

1. Create an AWS account
2. Create an EC2 instance (with the latest version of Amazon Lunix AMI)
3. Make sure the ports are setup.
4. Download the pem file during setup.
5. Once the instance is up, run `ssh -i alex.pem ec2-user@ec2-54-201-167-144.us-west-2.compute.amazonaws.com`
6. Follow http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html
7. Note that docker compose does not work due to the old docker machine used on AWS. (as-of May 2016)

#### RDS

[Importing and Exporting SQL Server Databases](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/SQLServer.Procedural.Importing.html)

To make a backup of MSSQL database, connect to the database via Management
Studio (or Visual Studio Code) and execute the following stored procedure.

To make sure backup is compressed,

```sql
exec rdsadmin..rds_set_configuration 'S3 backup compression', 'true';
```

To make a backup,

```sql
exec msdb.dbo.rds_backup_database
	@source_db_name='MyDatabaseName',
	@s3_arn_to_backup_to='arn:aws:s3:::my_bucket_name/my_backup_name.bak',
	@overwrite_S3_backup_file=1;
```

To check the progress of backups or restores,

```sql
exec msdb.dbo.rds_task_status @db_name='MyDatabaseName'
```

To download a backup from S3 via aws-cli,

```console
aws s3 cp s3://my_bucket_name/my_backup_name.bak my_backup_name.bak
```

To upload a backup onto S3 via aws-cli,

```console
aws s3 cp my_backup_name.bak s3://my_bucket_name/my_backup_name.bak
```

To restore a backup,

```sql
exec msdb.dbo.rds_restore_database
	@restore_db_name='MyDatabaseName',
	@s3_arn_to_restore_from='arn:aws:s3:::my_bucket_name/my_backup_name.bak';
```

