#### Basics

###### To login

```sh
gcloud auth login
```

###### To list current configuration

```sh
gcloud config list
```

###### To set default zone

```sh
gcloud config set compute/zone asia-east1-b
```

###### To change project

```sh
gcloud config set core/project google-cloud-platform-project-name
```

#### Kubernetes

###### To install kubernetes

```sh
gcloud components install kubectl
```

###### To create a kubernetes cluster

```sh
gcloud container clusters create your-cluster-name \
  -m f1-micro \
  --num-nodes=1
```

###### To set credentials on local machine to access kubernetes clusters

```sh
gcloud container clusters get-credentials your-cluster-name
```

###### To add docker login to the current kubernetes cluster

```sh
kubectl create secret docker-registry regsecret \
  --docker-server=docker.io \
  --docker-username=your-username \
  --docker-password=your-password \
  --docker-email=your-email
```

Note: you may also want to add the following to docker containers in deployment YAML files

```yaml
imagePullSecrets:
- name: regsecret
```

###### To create deployment or service to the current cluster (where `directory-to-files` contains the YAML files of deployments, and/or services, etc)

```sh
kubectl create -f directory-to-files/
```

###### To delete pods from configuration files (`.json` or `.yaml`)

```sh
kubectl delete -f directory-to-files/
```

###### To list clusters

```sh
gcloud container clusters list
```

###### To check status of pods

```sh
kubectl get pods
```

###### To check if there is a problem in creating a pod

```sh
kubectl describe pod any-pod-name
```

###### To check logs of a pod

```sh
kubectl logs pod-name
```

###### To list services deployed (and check external IP exposed)

```sh
kubectl get svc
```

###### To delete a service

```sh
kubectl delete services any-service-name
```

###### To delete a container cluster

```sh
gcloud container clusters delete any-project-name-cluster
```

###### To force delete a pod

```sh
kubectl delete pod --grace-period=0 --force my-pod-name
```

###### To change the number of nodes in a cluster

```sh
gcloud container clusters resize your-cluster-name --size=1
```

###### To migrate workloads to a different machine type

```sh
gcloud container node-pools create new-pool-name \
  --cluster your-cluster-name \
  --machine-type=f1-micro \
  --num-nodes=10

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do kubectl cordon "$node"; done

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do kubectl drain --force --ignore-daemonsets "$node"; done

gcloud container node-pools delete default-pool --cluster your-cluster-name
```

###### To list accessible clusters

```sh
kubectl config get-contexts
```

###### To change to access another cluster

```sh
kubectl config use-context a-context-name
```

A kubernetes service can be exposed externally by assigning it as type `LoadBalancer` (see [Connect a Front End to a Back End Using a Service](https://kubernetes.io/docs/tasks/access-application-cluster/connecting-frontend-backend/))

###### To tag and push images onto Google Container Registry

```sh
docker tag image-name:latest asia.gcr.io/project-name/image-name
gcloud docker push asia.gcr.io/project-name/image-name
```

###### Minikube

```sh
# to start
minikube start

# to stop
minikube stop

# to get IP and port of the running service
minikube service your-service-name --url
```

###### Links

- [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- [Configuration Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
- [Web UI (Dashboard)](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
- [kubectl -Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

#### Compute

###### To create an instance

```sh
gcloud compute instances create my-instance-name --machine-type f1-micro
```

###### To configure firewall for HTTP and HTTPS traffic

```sh
gcloud compute firewall-rules create instance-rule --allow tcp:80,tcp:443
```

###### To create a persistent volume

```sh
gcloud compute disks create --size 1GB my-disk-name
```

###### To attach a persistent disk to an instance ([reference](https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting))

```sh
gcloud compute instances attach-disk my-instance-name --disk my-disk-name
```

On the instance,

```sh
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
mkdir my-mount
sudo mount -o discard,defaults /dev/sdb ./my-mount
sudo chmod a+w ./my-mount
```

###### To list instances

```sh
gcloud compute instances list
```

###### To list disks created

```sh
gcloud compute disks list
```

###### To upload a directory onto an instance

```sh
gcloud compute scp ./my-source my-instance-name:/home/user/my-source --recurse
```

###### To list available machine types (see also [Machine Types](https://cloud.google.com/compute/docs/machine-types))

```sh
gcloud compute machine-types list
```

###### To authenticate to Container Registry on GCP

Execute on the instance,

```sh
gcloud auth configure-docker
```

