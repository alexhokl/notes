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

To set credentials for containers (especially for `kubectl`) [not sure if `GOOGLE_APPLICATION_CREDENTIALS` is required]
```sh
gcloud container clusters get-credentials any-project-name-cluster
```

To tag and push images onto Google Container Registry
```sh
docker tag image-name:latest asia.gcr.io/project-name/image-name
gcloud docker push asia.gcr.io/project-name/image-name
```

To create a container cluster (and getting the IP of master node)
```sh
gcloud container clusters create any-project-name-cluster \
  --num-nodes 3 \
  --machine-type f1-micro
```

To create pods from configuration files (`.json` or `.yaml`)
```sh
kubectl create -f directory-to-files/
```

To delete pods from configuration files (`.json` or `.yaml`)
```sh
kubectl delete -f directory-to-files/
```

To check status of pods
```sh
kubectl get pods
```

To check logs of a pod
```sh
kubectl logs pod-name
```

To delete a service
```sh
kubectl delete services any-service-name
```

To delete a pod
```sh
kubectl delete deployment any-pod-name
```

To delete a container cluster
```sh
gcloud container clusters delete any-project-name-cluster
```

To list instances
```sh
gcloud compute instances list
```

To list clusters
```sh
gcloud container clusters list
```

To list disks created
```sh
gcloud compute disks
```

To list available machine types
```sh
gcloud compute machine-types list
```
