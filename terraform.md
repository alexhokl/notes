- [Links](#links)
- [Commands](#commands)
  * [Basic](#basic)
  * [Import](#import)
  * [Removal](#removal)
  * [Refactoring](#refactoring)
____

## Links

- [Writing Terraform for unsupported
  resources](https://www.hashicorp.com/blog/writing-terraform-for-unsupported-resources)

## Commands

### Basic

##### To initialise and upgrade state file with latest versions

```sh
terraform init -reconfigure -upgrade
```

##### To list all the Terraform-managed resources

```sh
terraform state list
```

### Import

##### To import existing resources

Assuming an `import` block (like the following) has been define in a `.tf` file.

```terraform
import {
 # ID of the cloud resource
 # Check provider documentation for importable resources and format
 id = "import-bucket-tf15-2"
 # Resource address
 to = aws_s3_bucket.this2
}
```

```sh
terraform plan -generate-config-out=generated_resources.tf
```

Note that the `import` block should not be removed until `terraform apply` has
been ran. Otherwise, the added resource will be treated as creation but not
import.

### Removal

##### To remove a resource from state but not from infrastructure

```sh
terraform state rm 'some_resource_type.worker'
```

#### To remove a resource cannot be removed by terraform apply

```sh
terraform destroy -target=module.hangfire-postgres.helm_release.hangfire-postgres
```

### Refactoring

##### To rename a resource

Assume the original name of resource is `worker` and it has been renamed to
`helper` in a `.tf` file.

```sh
terraform state mv some_resource_type.worker some_resource_type.helper
```

##### To move a resource into a module

```sh
terraform state mv 'some_resource_type.worker' 'module.worker.some_resource_type.main'
```

Note that it is best to surround resource with single quote especially in case
of square brackets `[]` are used.

##### Moving resources from one state to another

Reference: [How to Merge State
Files](https://support.hashicorp.com/hc/en-us/articles/4418624552339-How-to-Merge-State-Files)

If the state files has a backend configured, the state has to be pulled into
a local directory first.

Assuming the following directory setup with the existing `.tf` files.

- `~/source/`
- `~/destination/`

```sh
mkdir -p ~/remote
cd ~/source
terraform state pull > ~/remote/source.tfstate
cd ~/destination
terraform state pull > ~/remote/destination.tfstate

terraform state mv -state=~/remote/source.tfstate -state-out=~/remote/source.tfstate some_resource_type.some_name some_resource_type.some_new_name

terraform state list -state=~/remote/destination.tfstate

_CURRENT_SERIAL=$(cat ~/remote/destination.tfstate | jq -r '.serial')
_NEXT_SERIAL=$(($_CURRENT_SERIAL + 1))
cat ~/remote/destination.tfstate | jq ".serial = $_NEXT_SERIAL" > ~/remote/destination_new.tfstate
terraform state push ~/remote/destination_new.tfstate

_CURRENT_SERIAL=$(cat ~/remote/source.tfstate | jq -r '.serial')
_NEXT_SERIAL=$(($_CURRENT_SERIAL + 1))
cat ~/remote/source.tfstate | jq ".serial = $_NEXT_SERIAL" > ~/remote/source_new.tfstate
terraform state push ~/remote/source_new.tfstate
```
