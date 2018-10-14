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

##### TO list resource groups

```sh
az group list | jq '.[] .name'
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
