# azure-cli

### Account/Subscription

##### To list the accounts/subscriptions

```sh
az account list | jq '.[] | { default:.isDefault, id:.id }'
```

##### To set the account/subscription to use

```sh
az account set -s YourSubscriptionId
```

### Resource Groups

##### To list resource groups

```sh
az group list | jq '.[] .name'
```

or in a table

```sh
az group list -o table
```

### Networking

##### To list all public IPs

```sh
az network public-ip list -o table
```

##### To create a public IP in a resource group

```sh
az network public-ip create -g your-resource-group-name -n your-name-to-this-ip
```

##### To list network interfaces in a resource group

```sh
az network nic list -g your-resource-group-name -o table
```

##### To attach an IP to a network interface

```sh
az network nic ip-config update -g your-resource-group-name --nic-name your-network-interface-name --name your-name-of-this-config --public-ip-address your-name-of-the-ip
```

##### To set DNS name to an IP

```sh
IP=123.123.123.123
RESOURCE_ID=$(az network public-ip list -o json | jq -r --arg IP "$IP" '.[] | select(.ipAddress==$IP) | .id')
az network public-ip update --ids $RESOURCE_ID --dns-name your-dns-name
```

### AKS

##### To list all clusters

```sh
az aks list | jq '.[] | .name'
```

with its FQDN

```sh
az aks list | jq '.[] | .fqdn'
```

##### To set `kubectl` credentials

```sh
az aks get-credentials --resource-group YourResourceGroupName --name your-aks-name
```

##### To browse Kubernetes dashboard

```sh
az aks browse --resource-group your-resource-group-name --name your-aks-name
```

##### Unable to provision a service with load balancer

The scenario is that the service is kept in `pending` state due to its
inability to provision/associate with an external fixed IP. By describing the
service, it may give an error message similar to `Error creating load balancer
(will retry): failed to ensure load balancer for service some-serivce-name:
timed out waiting for the condition`. It is likely that the IP was not clean up
properly during the last service deletion. To do the clean-up manually,

1. Log onto [Azure Portal](https://portal.azure.com/).
2. Navigate to page `Public IP addresses` and click on the IP involved.
3. Click on the link next to `Associated to`.
4. Select section `Frontend IP configuration`.
5. Try to delete the IP address involved.
6. Re-provision the service again.

### ACR

##### To list all registries

```sh
az acr list | jq '.[] .name'
```

##### To list all repositories in a registry

```sh
az acr repository list --name YourRegistryName | jq
```

##### To remove a repository

```sh
az acr repository delete -n your-acr-short-name --repository your-repo-name
```

##### To remove an image from a repository

```sh
az acr repository delete -n MyRegistry --image hello-world:latest
```

##### To list all tags in repository

```sh
az acr repository show-tags --name YourRegistryName --repository YourRepoName | jq
```

##### To remove a tag in repository

```sh
az acr repository untag -n YourRegistryName --image YourRepoName:YourTagName
```

##### To perform a Docker login

```sh
az acr login -n short-name-of-acr
```

##### To create a Docker login (by creating a role)

```sh
az ad sp create-for-rbac --scopes /subscriptions/{SubID}/resourceGroups/{ResourceGroup1}/providers/Microsoft.ContainerRegistry/registries/{acrName} --role Contributor --name your-credential-name
```

where
    `SubID` is the subscription ID,
    `ResourceGroup1` is the name of resource group,
    `acrName` is the short name of the ACR

### Active Directory

##### To list all security principals

and show display name and service type

```sh
az ad sp list --all | jq '.[] | { name: .displayName, type: .servicePrincipalType }'
```

### Roles

##### To list all roles available

```sh
az role definition list -o table
```

##### To list all roles assignments

```sh
az role assignment list --all -o table
```

##### To list all roles assignments in a resource group

```sh
az role assignment list --all | jq '.[] | select(.resourceGroup=="your-resource-group-name")'
```

##### To update service principal after expiration

```sh
SP_ID=$(az aks show --resource-group your-resource-group --name your-cluster-name --query servicePrincipalProfile.clientId -o tsv)
SP_SECRET=$(az ad sp credential reset --name $SP_ID --query password -o tsv)
az aks update-credentials --resource-group your-resource-group --name your-cluster-name --reset-service-principal --service-principal $SP_ID --client-secret $SP_SECRET
```

Note that, by default, the service principal expires in a year (as a security
practice).

Also note that, all the nodes must be in state `running` otherwise it would
result in exceptions.

See also [Update or rotate the credentials for a service principal in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/update-credentials).

### Virtual Machine

##### To list all the machines

```sh
az vm list -g your-resource-group -o table
```

### SQL Database

##### To kickstart an export

```sh
az sql db export -s your-server-name -n your-database-name -g your-resource-group-name --admin-user your-sql-username --admin-password your-sql-password --storage-key your-azure-storage-key --storage-key-type StorageAccessKey --storage-uri your-full-uri-on-blob-storage
```

Note that `your-full-uri-on-blob-storage` must include the file name as well.

##### To list all database servers

```sh
az sql server list -o table
```

##### To show information of a database server

```sh
az sql server show -g your-resource-group-name -n your-database-name
```

##### To list all databases in a database server

```sh
az sql db list -g your-resource-group-name -s your-server-name -o table
```

##### To create a database in a database server

```sh
az sql db create -g your-resource-group-name -s your-server-name -n name-of-new-database -e GeneralPurpose -f Gen4 -c 4 --max-size 200GB
```

##### To delete a database in a database server

```sh
az sql db delete -g your-resource-group-name -s your-server-name -n name-of-database-to-be-deleted -y
```

##### To list operations performed on a database

```sh
az sql db op list -g your-resource-group-name -s your-database-server-name -d your-database-name
```

### Azure Storage

#### Storage Account

##### To list all storage accounts

```sh
az storage account list -o table
```

##### To list keys of a storage account

```sh
az storage account keys list -n your-storage-account-name
```

##### To get connection string of a storage account

```sh
az storage account show-connection-string -n your-storage-account-name | jq -r '.connectionString'
```

#### Azure Blob Storage

##### To list all buckets/containers

```sh
az storage container list --connection-string your-connection-string-to-storage-account -o table
```

##### To list all object names in a bucket/container

```sh
az storage blob list --connection-string your-connection-string-to-storage-account -c your-bucket-name | jq '.[] | .name'
```

##### To download a file from a bucket/container

```sh
az storage blob download --connection-string your-connection-string-to-storage-account -c your-bucket-name --name your-filename-in-bucket -f your-local-destination-path
```

##### To upload a file onto a bucket/container

```sh
az storage blob upload --connection-string your-connection-string-to-storage-account -c your-bucket-name --name your-filename-in-bucket -f your-local-source-path
```

##### To upload multiple files onto a bucket/container

```sh
az storage blob upload-batch --connection-string your-connection-string-to-storage-account -d your-bucket-name -s your-local-directory --pattern *.txt
```

#### Azure Files

##### To list all shares in a storage account

```sh
az storage share list --connection-string your-connection-string-to-storage-account -o table
```

##### To list all files in a share

```sh
az storage file list --connection-string your-connection-string-to-storage-account -s your-share-name -o table
```

##### To list all files in a share in a path

```sh
az storage file list --connection-string your-connection-string-to-storage-account -s your-share-name -o table --path your/path/to/directory
```

### Azure Disk

##### To list all disks

```sh
az disk list | jq '.[] | { name: .name, os: .osType, sku: .sku.name, size: .diskSizeGb, diskIopsReadWrite: .diskIopsReadWrite, provisioningState: .provisioningState, diskState: .diskState}'
```

or in a table

```sh
az disk list -o table
```

