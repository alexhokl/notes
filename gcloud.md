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
gcloud container clusters create your-cluster-name -m n1-standard-2 --num-nodes=3
```

###### To set credentials on local machine to access kubernetes clusters

```sh
gcloud container clusters get-credentials your-cluster-name
```

###### To list clusters

```sh
gcloud container clusters list
```

###### To delete a container cluster

```sh
gcloud container clusters delete any-project-name-cluster
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

A kubernetes service can be exposed externally by assigning it as type `LoadBalancer` (see [Connect a Front End to a Back End Using a Service](https://kubernetes.io/docs/tasks/access-application-cluster/connecting-frontend-backend/))

###### To tag and push images onto Google Container Registry

```sh
docker tag image-name:latest asia.gcr.io/project-name/image-name
gcloud docker push asia.gcr.io/project-name/image-name
```

###### To allow pulling docker images from another project

Suppose the image in docker registry of `your-project-a` is used in cluster of
`your-project-b`,

```sh
gcloud config set core/project your-project-b
SVC_EMAIL=$(gcloud iam service-accounts list --filter="Compute Engine default service account" --format=json | jq -r '.[] | .email')
gcloud projects add-iam-policy-binding your-project-a --member=serviceAccount:${SVC_EMAIL} --role roles/storage.objectViewer
```

###### To create roles for Helm

```sh
kubectl --user=admin/your-cluster-name create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gc config get-value account)
kubectl create serviceaccount --namespace=kube-system tiller
kubectl create clusterrolebinding tiller-clusterrolebinding --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --wait
```

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

