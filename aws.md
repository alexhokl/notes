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

###### To look for existing templates

```sh
dotnet new
```

#### CLI (Reference)[https://docs.aws.amazon.com/cli/latest/reference/lambda/]

###### To list all functions

```sh
aws lambda list-functions | jq '.[][]'
```

###### To list all function names and runtimes

```sh
aws lambda list-functions | jq '.[][] | { name: .FunctionName, runtime: .Runtime }'
```
###### To get the link to download lambda function

```sh
aws lambda get-function --function-name test1 | jq '.Code.Location'
```

###### To create a function

```sh
aws lambda create-function \
	--function-name my-function-name \
	--runtime dotnetcore2.0 \
	--role arn:aws:iam::000000000::role/my-worker \
	--description "A test lambda function created from command line" \
	--code S3Bucket=my_bucket_name,S3Key=my_key,S3ObjectVersion=my_version \
	--handler MyAssembleName::MyClassNameWithNameSpace::MyMethodName
```

### SNS

#### Message size and format

- message size limit is 256KB
- message sizes between 64KB and 256KB must use AWS Signature Version 4 (SigV4) signing (see [ref](https://docs.aws.amazon.com/sns/latest/dg/large-payload-raw-message.html))
- message delivers to SQS or HTTP/S endpoints could be in raw instead of JSON (see [ref](https://docs.aws.amazon.com/sns/latest/dg/large-payload-raw-message.html))

#### CLI (Reference)[https://docs.aws.amazon.com/cli/latest/reference/sns/]

###### To list all topics

```sh
aws sns list-topics | jq '.[][] | .TopicArn'
```

### SQS

#### Message size and format

- message size limit is 256KB (unless Java library is used)
- message can be in JSON, XML and unformatted text
- a queue name can have up to 80 characters

### IAM

#### CLI (Reference)[https://docs.aws.amazon.com/cli/latest/reference/iam/]

###### To list all roles

```sh
aws iam list-roles | jq '.[][] | { name: .RoleName, path: .Path, arn: .Arn }'
```

### EC2

-	Always create a IAM role with an EC2 instance.

###### Add an inbound rule

```sh
aws ec2 authorize-security-group-ingress --group-id sg-11111111 --protocol tcp --port 1433 --cidr 123.123.123.123/24
```
