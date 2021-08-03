- [Login](#login)
- [Account/Subscription](#accountsubscription)
- [Resource Groups](#resource-groups)
- [Networking](#networking)
  * [Public IP addresses](#public-ip-addresses)
  * [Network interfaces](#network-interfaces)
  * [Network Security Group (NSG)](#network-security-group-nsg)
  * [Private zones and links](#private-zones-and-links)
- [AKS](#aks)
- [ACR](#acr)
- [Active Directory](#active-directory)
- [Roles](#roles)
- [Virtual Machine](#virtual-machine)
- [SQL Database](#sql-database)
- [PostgreSQL](#postgresql)
- [Azure Storage](#azure-storage)
- [Azure Disk](#azure-disk)
- [azcopy](#azcopy)
- [Application Insights](#application-insights)
____

## Login

##### Using service principal (service account)

```sh
az login --service-principal --username $AZURE_APP_ID --password $AZURE_APP_PASSWORD --tenant $AZURE_TENANT_ID
```

## Account/Subscription

##### To list the accounts/subscriptions

```sh
az account list | jq '.[] | { default:.isDefault, id:.id }'
```

##### To set the account/subscription to use

```sh
az account set -s YourSubscriptionId
```

## Resource Groups

##### To list resource groups

```sh
az group list | jq '.[] .name'
```

or in a table

```sh
az group list -o table
```

## Networking

### Public IP addresses

##### To list all public IPs

```sh
az network public-ip list -o table
```

##### To create a public IP in a resource group

```sh
az network public-ip create -g your-resource-group-name -n your-name-to-this-ip
```

##### To list all virtual networks

```sh
az network vnet list -o table
```

##### To list all subnets within a virtual network

```sh
az network vnet subnet list -g your-group --vnet-name your-vnet -o table
```

### Network interfaces

##### To list network interfaces in a resource group

```sh
az network nic list -g your-resource-group-name -o table
```

##### To list IP addresses of a network interface

```sh
az network nic ip-config list -g your-group --nic-name your-nic -o table
```

##### To list all IP addresses of all network interfaces of all resource groups

```sh
for g in $(az group list | jq -r '.[] | .name'); do
	for n in $(az network nic list -g $g  | jq -r '.[] | .name'); do
		for ip in $(az network nic ip-config list -g $g --nic-name $n | jq -r '.[] | .privateIpAddress'); do
			echo $g $n $ip
		done
	done
done
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

### Network Security Group (NSG)

##### To list network security groups

```sh
az network nsg list | jq -r '.[] | {name:.name, rg:.resourceGroup}'
```

##### To list rules related to a specified destination port

```sh
az network nsg list | jq -r '.[] | select(.name=="your-nsg-name") | .securityRules[] | select(.destinationPortRange=="1433")'
```

##### To update a NSG rule to have a specific source IP

```sh
az network nsg rule update -g your-resource-group-name --nsg-name your-nsg-name -n your-nsg-rule-name --source-address-prefix '300.300.300.300'
```

### Private zones and links

##### To list the zones of private DNS

```sh
az network private-dns zone list -o table
```

##### To list A records of a private DNS zone

```sh
az network private-dns record-set a list -g your-resource-group -z your-zone-name | jq '.[] | { fqdn:.fqdn, ip:.aRecords[0].ipv4Address }'
```

##### To list all private endpoints

```sh
az network private-endpoint list -o table
```

## AKS

##### Cluster token

`kubernetes.io/service-account-token` will be expired every year by default.
Although it could be configured to be never expired.

See [Update or rotate the credentials for a service principal in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/update-credentials)

##### To list all clusters

```sh
az aks list | jq '.[] | { name:.name, rg:.resourceGroup, fqdn:.fdqn }'
```

##### To set `kubectl` credentials

```sh
az aks get-credentials --resource-group your-resource-group-name --name your-aks-name --context your-custom-name
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

##### To SSH into one of the nodes

Assuming there is a SSH private and public key pair ready as `azure.pub` and
`azure.pem`.

Generate SSH keys.

```sh
ssh-keygen -t rsa -b 4096 -f azure -v
mv azure azure.pem
chmod 600 azure.pem
```

To list the nodes

```sh
CLUSTER_RESOURCE_GROUP=$(az aks show --resource-group your-resource-group-name --name your-cluster-name --query nodeResourceGroup -o tsv)
az vm list --resource-group $CLUSTER_RESOURCE_GROUP -o table
```

Choose the node involved and upload the SSH public key onto it

```sh
az vm user update --resource-group $CLUSTER_RESOURCE_GROUP --name your-node-name --username azureuser --ssh-key-value azure.pem
```

See [To SSH into a node (with a SSH key already been setup on the
node)](https://github.com/alexhokl/notes/blob/master/kubernetes.md#to-ssh-into-a-node-with-a-ssh-key-already-been-setup-on-the-node)
for the rest of the steps.

##### To run a script on a node of a cluster

```sh
CLUSTER_RESOURCE_GROUP=$(az aks show --resource-group your-resource-group-name --name your-cluster-name --query nodeResourceGroup -o tsv)
CLUSTER_FIRST_NODE_NAME=$(az vm list --resource-group $CLUSTER_RESOURCE_GROUP | jq -r '.[0] | .name')
az vm run-command invoke -g $CLUSTER_RESOURCE_GROUP -n $CLUSTER_FIRST_NODE_NAME --scripts "cat /etc/kubernetes/azure.json" --command-id RunShellScript
```

##### To check available versions on Azure

```sh
az aks get-versions --location southeastasia --output table
```

##### To enable network policy (Calico)

```sh
az aks create \
    --resource-group your-resource-group-name \
    --name your-cluster-name \
    --node-count 3 \
    --generate-ssh-keys \
    --network-plugin azure \
    --network-policy calico
```

##### To update credential of a service principal after credential expiration

```sh
SP_ID=$(az aks show --resource-group your-resource-group --name your-cluster-name --query servicePrincipalProfile.clientId -o tsv)
SP_PASSWORD=$(az ad sp credential reset --name $SP_ID --query password -o tsv)
az aks update-credentials --resource-group your-resource-group --name your-cluster-name --reset-service-principal --service-principal $SP_ID --client-secret $SP_PASSWORD
```

Note that, by default, the password of a service principal expires in a year (as
a security practice).

Also note that, all the nodes must be in state `running` otherwise it would
result in exceptions.

See also [Update or rotate the credentials for a service principal in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/update-credentials).

## ACR

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
az acr repository show-tags --name YourRegistryName --repository YourRepoName | jq -r '.[]'
```

##### To remove a tag in repository

```sh
az acr repository untag -n YourRegistryName --image YourRepoName:YourTagName
```

##### To perform a Docker login

```sh
az acr login -n short-name-of-acr
```

##### To create a Docker login (by creating a service principal)

```sh
az ad sp create-for-rbac --scopes /subscriptions/{SubID}/resourceGroups/{ResourceGroup1}/providers/Microsoft.ContainerRegistry/registries/{acrName} --role Contributor --name your-credential-name
```

where
    `SubID` is the subscription ID,
    `ResourceGroup1` is the name of resource group,
    `acrName` is the short name of the ACR

##### To purge all images older than 1 day

```sh
az acr run --cmd "acr purge --filter 'your-image:.*' --ago 1d --untagged" --registry YourRepoName /dev/null
```

## Active Directory

##### To list all security principals

and show display name and service type

```sh
az ad sp list --all | jq '.[] | { name: .displayName, type: .servicePrincipalType }'
```

##### To show the details of a service principal

```sh
az ad sp show --id $SP_ID
```

##### To list roles of a service principal

```sh
az role assignment list --all | jq '.[] | select(.principalName=="http://your_sp_name") | .scope'
```

Note that name of service principal is used here but not ID of it.

##### To create a service principal

```sh
SP_JSON=$(az ad sp create-for-rbac --skip-assignment --name your-credential-name -o json)
SP_ID=$(echo $SP_JSON | jq -r '.appId')
SP_PASSWORD=$(echo $SP_JSON | jq -r '.password')
```

##### To assign a role to a service principal

```sh
az role assignment create --assignee $SP_ID --scope "/your/long/scope/path" --role Contributor
```

where `--scope` could be the `id` of a resource.

##### To list all credentials of a service principal

```sh
az ad sp credential list --id $SP_ID -o table
```

##### To reset credential of a service principal

```sh
az ad sp credential reset --name $SP_ID
```

## Roles

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

## Virtual Machine

##### To list all the machines

```sh
az vm list -g your-resource-group -o table
```

## SQL Database

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

##### To list managed instances

```sh
az sql mi list -o table
```

## PostgreSQL

##### To list all servers

```sh
az postgres server list -o table
```

##### To create a server

```sh
az postgres server create -n your-db --backup-retention 35 -g your-group -l southeastasia --geo-redundant-backup Enabled --minimal-tls-version TLS1_2 --public-network-access Enabled --sku-name GP_Gen5_2 --ssl-enforcement Enabled --storage-size 10240 --version 11 -u admin-username -p your-strong
```

##### To add a firewall rule to a server

```sh
az postgres server firewall-rule create -s your-db -g your-group -n your-rule-name --start-ip-address 300.300.300.300 --end-ip-address 300.300.300.300
```

## Azure Storage

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
az storage container list --connection-string $AZURE_STORAGE_CONNECTION_STRING -o table
```

##### To list all object names in a bucket/container

```sh
az storage blob list --connection-string $AZURE_STORAGE_CONNECTION_STRING -c $CONTAINER_NAME | jq '.[] | .name'
```

##### To download a file from a bucket/container

```sh
az storage blob download --connection-string $AZURE_STORAGE_CONNECTION_STRING -c $CONTAINER_NAME --name your-filename-in-bucket -f your-local-destination-path
```

##### To upload a file onto a bucket/container

```sh
az storage blob upload --connection-string $AZURE_STORAGE_CONNECTION_STRING -c $CONTAINER_NAME --name your-filename-in-bucket -f your-local-source-path
```

##### To upload multiple files onto a bucket/container

```sh
az storage blob upload-batch --connection-string $AZURE_STORAGE_CONNECTION_STRING -d $CONTAINER_NAME -s your-local-directory --pattern *.txt
```

##### To delete files from blob storage after a period of time

```sh
date=`date -d "2 days ago" '+%Y-%m-%dT%H:%MZ'`
az storage blob delete-batch --connection-string $AZURE_STORAGE_CONNECTION_STRING -s $CONTAINER_NAME --if-unmodified-since $date
```

or with a pattern,

```sh
date=`date -d "2 days ago" '+%Y-%m-%dT%H:%MZ'`
az storage blob delete-batch --connection-string $AZURE_STORAGE_CONNECTION_STRING -s $CONTAINER_NAME --if-unmodified-since $date --pattern *.bak
```

#### Azure Files

##### To list all shares in a storage account

```sh
az storage share list --connection-string $AZURE_STORAGE_CONNECTION_STRING -o table
```

##### To list all files in a share

```sh
az storage file list --connection-string $AZURE_STORAGE_CONNECTION_STRING -s your-share-name -o table
```

##### To list all files in a share in a path

```sh
az storage file list --connection-string $AZURE_STORAGE_CONNECTION_STRING -s your-share-name -o table --path your/path/to/directory
```

## Azure Disk

##### To list all disks

```sh
az disk list | jq '.[] | { name: .name, os: .osType, sku: .sku.name, size: .diskSizeGb, diskIopsReadWrite: .diskIopsReadWrite, provisioningState: .provisioningState, diskState: .diskState}'
```

or in a table

```sh
az disk list -o table
```

## azcopy

##### To download a file from blob storage

```sh
azcopy copy 'https://<storage-account-name>.<blob or dfs>.core.windows.net/<container-name>/<blob-path>' '<local-file-path>'
```

##### To download a directory from blob storage

```sh
azcopy copy 'https://<storage-account-name>.<blob or dfs>.core.windows.net/<container-name>/<directory-path>' '<local-directory-path>' --recursive
```

## Application Insights

##### To enable commands related to Application Insights (since it is a preview)

```sh
az extension add -n application-insights
```

##### To list all Application Insights resources

```sh
az monitor app-insights component show -o table
```

To view instrumentation key,

```sh
az monitor app-insights component show | jq '.[] | { applicationId:.applicationId, instrumentationKey:.instrumentationKey }'
```
