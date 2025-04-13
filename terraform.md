- [Links](#links)
- [Concepts](#concepts)
- [Commands](#commands)
  * [Basic](#basic)
  * [Import](#import)
  * [Removal](#removal)
  * [Refactoring](#refactoring)
- [Recipes](#recipes)
  * [private DNS name of a private IP on VPC of GCP](#private-dns-name-of-a-private-ip-on-vpc-of-gcp)
____

## Links

- [Writing Terraform for unsupported
  resources](https://www.hashicorp.com/blog/writing-terraform-for-unsupported-resources)
- [OpenTofu](https://opentofu.org/)

## Concepts

- terraform state is not encrypted and it can conntain secrets
  * use a backend that supports encryption
    + AWS S3
    + GCP Cloud Storage
    + Azure Blob Storage
  * strict control who can access the backend
- since version `0.14`, variables can be marked as sensitive by `sensitive
  = true`
- variable can be set by using environment variables with prefix `TF_VAR_`
  * environment variables should be setup before `terraform apply`
- key service can be used but it is not the most secured implementation
  * examples of key services
    + AWS KMS
    + GCP Cloud KMS
    + Azure Key Vault
- secret stores should be used
  * Hashicorp Vault
  * AWS Secrets Manager
  * AWS Param Store
  * GCP Secret Manager

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

## Recipes

### private DNS name of a private IP on VPC of GCP

Note that this does not ensure encrypted traffic as certicates may not be issued
with the private DNS name.

```terraform
resource "google_dns_managed_zone" "private_zone" {
  name        = "private-zone"
  dns_name    = "internal.your-domain.com."
  description = "Internal DNS zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.vpc.network_self_link
    }
  }
}

resource "google_dns_record_set" "db_dns" {
  depends_on   = [google_dns_managed_zone.private_zone]
  managed_zone = google_dns_managed_zone.private_zone.name
  name         = "db.${google_dns_managed_zone.private_zone.dns_name}"
  rrdatas      = [google_sql_database_instance.instance.private_ip_address]
  ttl          = 300
  type         = "A"
}
```
