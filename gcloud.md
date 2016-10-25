To list current configuration
```sh
gcloud config list
```

To set default zone
```sh
gcloud config set compute/zone asia-east1-b
```

To change project
```sh
gcloud config set core/project google-cloud-platform-project-name
```

To install kubernetes
```sh
gcloud components install kubectl
```

To create a container cluster (and getting the IP of master node)
```sh
gcloud container clusters create any-project-name-cluster
```

To delete a container cluster
```sh
gcloud container clusters delete any-project-name-cluster
```
