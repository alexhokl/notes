##### Setting up Docker on AWS

1. Create an AWS account
2. Create an EC2 instance (with the latest version of Amazon Lunix AMI)
3. Make sure the ports are setup.
4. Download the pem file during setup.
5. Once the instance is up, run `ssh -i alex.pem ec2-user@ec2-54-201-167-144.us-west-2.compute.amazonaws.com`
6. Follow http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html
7. Note that docker compose does not work due to the old docker machine used on AWS. (as-of May 2016)
