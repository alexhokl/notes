- [RDS](#rds)
- [S3](#s3)
- [Lambda](#lambda)
- [SNS](#sns)
- [SQS](#sqs)
- [IAM](#iam)
- [EC2](#ec2)
- [Lightsail](#lightsail)
- [Account manager](#account-manager)
____

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

```sh
aws s3 cp s3://my_bucket_name/my_backup_name.bak my_backup_name.bak
```

###### Backup upload to S3

```sh
aws s3 cp my_backup_name.bak s3://my_bucket_name/my_backup_name.bak
```

###### Restoring a backup

```sql
exec msdb.dbo.rds_restore_database
	@restore_db_name='MyDatabaseName',
	@s3_arn_to_restore_from='arn:aws:s3:::my_bucket_name/my_backup_name.bak';
```

### S3

##### To apply public access

```sh
aws s3api put-object-acl --acl public-read --bucket your-bucket-name --key filename.txt
```

##### To show ACL of a bucket

```sh
aws s3api get-bucket-acl --bucket your-bucket-name | jq '.Grants[]'
```

##### To show CORS setting of a bucket

```sh
aws s3api get-bucket-cors --bucket your-bucket-name
```

##### To create a bucket

```sh
aws s3 mb s3://your-bucket-name
```

##### To copy recursively

```sh
aws s3 cp --recursive s3://your-bucket/ ./
```

##### To change tiering of objects in a directory

```sh
aws s3 cp --recursive --storage-class INTELLIGENT_TIERING s3://your-bucket-name s3://your-bucket-name
```

##### To enable public access of all the files in a bucket

Add the following to `Bucket policy`.

```sh
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-bucket/*"
        }
    ]
}
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

#### CLI [Reference](https://docs.aws.amazon.com/cli/latest/reference/lambda/)

###### To list all functions

```sh
aws lambda list-functions | jq '.Functions[] | { name:.FunctionName, handler:.Handler, runtime:.Runtime}'
```

###### To get the link to download lambda function

```sh
aws lambda get-function --function-name test1 | jq '.Code.Location'
```

##### To create a lambda function

```sh
aws lambda create-function --function-name your-function --runtime dotnetcore2.0 --role arn:aws:iam::123345567:role/your-worker-role --description "A Description" --code S3Bucket=string,S3Key=string,S3ObjectVersion=string --handler Name.Space::Name.Space.ClassName::MethodName
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
aws sns list-topics | jq -r '.[][] | .TopicArn'
```

##### To list subscription by topic

```sh
aws sns list-subscriptions --topic-arn arn:aws:sns:ap-east-1:123345567:your-topic-name
```

##### To create a topic

```sh
aws sns create-topic --name your-topic-name
```

##### To delete a topic

```sh
aws sns delete-topic --topic-arn arn:aws:sns:ap-east-1:1233345567:your-topic-name
```

### SQS

#### Message size and format

- message size limit is 256KB (unless Java library is used)
- message can be in JSON, XML and unformatted text
- a queue name can have up to 80 characters

### IAM

- [CLI (Reference)](https://docs.aws.amazon.com/cli/latest/reference/iam/)
- [AWS Policy Generator](https://awspolicygen.s3.amazonaws.com/policygen.html)

###### To list all roles

```sh
aws iam list-roles | jq '.[][] | { name: .RoleName, path: .Path, arn: .Arn }'
```

##### To list custom policies

```sh
aws iam list-policies --scope Local | jq -r '.Policies[] | .Arn'
```

##### To get basic information of a custom policy

```sh
aws iam list-policies --scope Local | jq -r '.Policies[] | select(.PolicyName=="your-policy-name")'
```

##### To get versions of a custom policy

```sh
aws iam list-policy-versions --policy-arn arn:aws:iam::12345678:policy/your-policy-name
```

##### To get definition of a policy

```sh
aws iam get-policy-version --policy-arn arn:aws:iam::12345678:policy/your-policy-name --version-id v4
```

##### To create a policy

```sh
aws iam create-policy --policy-name your-policy --policy-document file://policy.json --description "A description"
```

##### To update a policy

```sh
aws iam create-policy-version --policy-name your-policy --policy-document file://policy.json
```

##### To list a policies attached to a user

```sh
aws iam list-attached-user-policies --user-name your-username
```

##### To attach a policy to a user

```sh
aws iam attach-user-policy --user-name your-username --policy-arn arn:aws:iam::12345678:policy/your-policy
```

##### To detach a policy to a user

```sh
aws iam detach-user-policy --user-name your-username --policy-arn arn:aws:iam::12345678:policy/your-policy
```

##### To create a user

```sh
aws iam create-user --user-name your-username
```

##### To create a password for a user

```sh
aws iam create-login-profile --user-name your-username --password your-strong-password
```
##### To update password for a user

```sh
aws iam update-login-profile --user-name your-username --password your-strong-password
```

##### To add a user to a group

```sh
aws iam add-user-to-group --group-name your-group-name --user-name your-username
```

##### To list groups a user attached to

```sh
aws iam list-groups-for-user --user-name your-username
```

### EC2

- [CPU Credits and Baseline Performance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/t2-credits-baseline-concepts.html)
-	Always create a IAM role with an EC2 instance.

###### Add an inbound rule

```sh
aws ec2 authorize-security-group-ingress --group-id sg-11111111 --protocol tcp --port 1433 --cidr 123.123.123.123/24
```

##### To show security groups

```sh
aws ec2 describe-security-groups | jq '.[][] | { groupName:.GroupName, description:.Description }'
```

##### To list instances

```sh
aws ec2 describe-instances | jq '.Reservations[] | .Instances[] | {id:.InstanceId, keyName:.KeyName, ip:.NetworkInterfaces[0].Association.PublicIp}'
```

### Lightsail

#### Directories and files

- Plugins - `/opt/bitnami/apps/wordpress/htdocs/wp-content/plugins/`
- Major configuration file - `/opt/bitnami/apps/wordpress/htdocs/wp-config.php`

##### To install Let's Encrypt (Lego) on the Ubuntu box ([reference](https://docs.bitnami.com/aws/how-to/generate-install-lets-encrypt-ssl/))

```sh
cd /tmp
curl -s https://api.github.com/repos/xenolf/lego/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4 | wget -i - -O lego.tar.gz
tar xf lego.tar.gz
sudo mv lego /usr/local/bin/lego
sudo /opt/bitnami/ctlscript.sh stop
sudo lego --email="alex@test.com" --domains="test.com" --domains="www.test.com" --path="/etc/lego" run
sudo mv /opt/bitnami/apache2/conf/server.crt /opt/bitnami/apache2/conf/server.crt.old
sudo mv /opt/bitnami/apache2/conf/server.key /opt/bitnami/apache2/conf/server.key.old
sudo mv /opt/bitnami/apache2/conf/server.csr /opt/bitnami/apache2/conf/server.csr.old
sudo ln -s /etc/lego/certificates/test.com.key /opt/bitnami/apache2/conf/server.key
sudo ln -s /etc/lego/certificates/test.com.crt /opt/bitnami/apache2/conf/server.crt
sudo chmod 600 /opt/bitnami/apache2/conf/server*
sudo /opt/bitnami/ctlscript.sh start
```

##### To renew Let's Encrypt (Lego) on the Ubuntu box ([reference](https://docs.bitnami.com/aws/how-to/generate-install-lets-encrypt-ssl/))

```sh
sudo /opt/bitnami/ctlscript.sh stop
sudo lego --email="alex@test.com" --domains="test.com" --domains="www.test.com" --path="/etc/lego" renew
sudo /opt/bitnami/ctlscript.sh start
```

In case of port `80` is not available, it is likely that there is another
`apache2` instance running. Use `sudo service apache2 status` to check and `sudo
service apache2 stop` to stop it from running and re-try the script above.

To automate the process, a script file can be created and execute using a cron
job. To edit cron schedule, use `sudo crontab -e` and use a line like the
following.

```crontab
0 0 1,16 * * /opt/bitnami/letsencrypt/update-cert.sh 2> /dev/null
```

##### To redirect http to https

Edit file `/opt/bitnami/apache2/conf/bitnami/bitnami-apps-prefix.conf` and add the following (to the top if not working properly)

```
RewriteEngine On
RewriteCond %{HTTPS} !=on
RewriteRule ^/(.*) https://%{SERVER_NAME}/$1 [R,L]
```

##### To set domain name of WordPress

Edit file `/opt/bitnami/apps/wordpress/htdocs/wp-config.php` and look for
`WP_SITEURL` and `WP_HOME`

### Account manager

AWS might be better in looking after a customer in that they provide dedicated
account manager whereas Google Cloud does not do.
