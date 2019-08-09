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

##### To list network interfaces in a resource group

```sh
az network nic list -g your-resource-group-name -o table
```

##### To create a public IP in a resource group

```sh
az network public-ip create -g your-resource-group-name -n your-name-to-this-ip
```

##### To attach an IP to a network interface

```sh
az network nic ip-config update -g your-resource-group-name --nic-name your-network-interface-name --name your-name-of-this-config --public-ip-address your-name-of-the-ip
```


### AKS

##### To list all

```sh
az aks list | jq '.[] .name'
```

##### To set `kubectl` credentials

```sh
az aks get-credentials --resource-group YourResourceGroupName --name YourAksName
```

##### To browse Kubernetes console

```sh
az aks browse --resource-group Staging --name staging-aks-gsc
```

### ACR

##### To list all registries

```sh
az acr list | jq '.[] .name'
```

##### To list all repositories in a registry

```sh
az acr repository list --name YourRegistryName | jq
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
az acr login --name short-name-of-acr
```

##### To create a Docker login (by creating a role)

```sh
az ad sp create-for-rbac --scopes /subscriptions/{SubID}/resourceGroups/{ResourceGroup1}/providers/Microsoft.ContainerRegistry/registries/{acrName} --role Contributor --name your-credential-name
```

where
    `SubID` is the subscription ID,
    `ResourceGroup1` is the name of resource group,
    `acrName` is the short name of the ACR
