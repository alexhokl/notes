- [Basics](#basics)
- [Kubernetes](#kubernetes)
- [Compute](#compute)
- [DNS](#dns)
- [Bucket](#bucket)
- [IAM](#iam)
____

### Basics

##### To check command installation

```sh
gcloud info
```

##### To login

```sh
gcloud auth login
```

##### To list existing logins

```sh
gcloud auth list
```

##### To echo out JWT token of the current login

```sh
gcloud auth print-identity-token
```

##### To list current configuration

```sh
gcloud config list
```

##### To set default zone

```sh
gcloud config set compute/zone asia-east1-b
```

##### To change project

```sh
gcloud config set core/project google-cloud-platform-project-name
```

##### To get project number from project ID

```sh
gcloud protjects list --filter="project_id:$PROJECT_ID" --format='value(project_number)'
```

### Kubernetes

##### To add credentials to $HOME/.kube/config

```sh
gcloud container clusters get-credentials your-cluster-name
```

##### To create a kubernetes cluster

```sh
gcloud container clusters create your-cluster-name -m n1-standard-2 --num-nodes=3
```

##### To set credentials on local machine to access kubernetes clusters

```sh
gcloud container clusters get-credentials your-cluster-name
```

##### To authenticate to Container Registry on GCP

```sh
gcloud auth configure-docker
```

Note that it can be executed on a GCP compute instance as well

##### To show cluster information

```sh
gcloud container clusters describe your-cluster-name
```

##### To list clusters

```sh
gcloud container clusters list
```

or, to restrict to a zone

```sh
gcloud container clusters list --zone asia-east1-b
```

##### To delete a container cluster

```sh
gcloud container clusters delete any-project-name-cluster
```

##### To change the number of nodes in a cluster

```sh
gcloud container clusters resize your-cluster-name --size=1
```

##### To migrate workloads to a different machine type

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

##### To tag and push images onto Google Container Registry

```sh
docker tag image-name:latest asia.gcr.io/project-name/image-name
gcloud docker push asia.gcr.io/project-name/image-name
```

##### To allow pulling docker images from another project

Suppose the image in docker registry of `your-project-a` is used in cluster of
`your-project-b`,

```sh
gcloud config set core/project your-project-b
SVC_EMAIL=$(gcloud iam service-accounts list --filter="Compute Engine default service account" --format=json | jq -r '.[] | .email')
gcloud projects add-iam-policy-binding your-project-a --member=serviceAccount:${SVC_EMAIL} --role roles/storage.objectViewer
```

##### To create roles for Helm 2

```sh
kubectl --user=admin/your-cluster-name create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gc config get-value account)
kubectl create serviceaccount --namespace=kube-system tiller
kubectl create clusterrolebinding tiller-clusterrolebinding --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --wait
```

##### To create a public IP address and assign it to a cluster running Ingress using Nginx

Assuming the region of the cluster is `asia-east2`,

```sh
gcloud compute addresses create my-cluster-ip --region asia-east2
IPADDR=$(gcloud compute addresses describe my-cluster-ip --region asia-east2 --format json | jq -r .address)
helm install nginx-ingress --namespace default stable/nginx-ingress --set controller.service.loadBalancerIP=$IPADDR
```

##### To enable network policy (Calico)

```sh
gcloud container clusters update your-cluster-name --update-addons=NetworkPolicy=ENABLED
gcloud container clusters update your-cluster-name --enable-network-policy
```

### Compute

##### To create an instance

```sh
gcloud compute instances create my-instance-name --machine-type f1-micro
```

or, with a specific VM image

```sh
gcloud compute instances create your-instance-name --image-family debian-8 --machine-type f1-micro
```

##### To configure firewall for HTTP and HTTPS traffic

```sh
gcloud compute firewall-rules create instance-rule --allow tcp:80,tcp:443
```

##### To list firewall rules

```sh
gcloud compute firewall-rules list
```

##### SSH

```sh
gcloud compute ssh your-username@your-instance-name
```

##### SCP

```sh
gcloud compute scp some.txt your-instance-name:/path/to/the/file
```

or, to copy recursively

```sh
gcloud compute scp some-directory video2:/path/to/a/directory/ --recurse
```

##### To create a persistent volume

```sh
gcloud compute disks create --size 1GB my-disk-name
```

##### To list disk provisioned

```sh
gcloud compute disks list
```

##### To delete a disk

```sh
gcloud compute disks delete your-disk-name
```

##### To describe a disk

```sh
gcloud compute disks describe your-disk-name
```

##### To attach a persistent disk to an instance ([reference](https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting))

```sh
gcloud compute instances attach-disk my-instance-name --disk my-disk-name
```

On the instance,

```sh
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
mkdir my-mount
sudo mount -o discard,defaults /dev/sdb ./my-mount
sudo chmod a+w ./my-mount
sudo chown alex.alex ./my-mount
```

##### To list instances

```sh
gcloud compute instances list
```

##### To describe an instance

```sh
gcloud compute instances describe your-instance-name
```

or, to list service accounts and scopes

```sh
gcloud compute instances describe your-instance-name --format='yaml(serviceAccounts[].scopes[])'
```

##### To delete an instance

```sh
gcloud compute instances delete your-instance-name
```

##### To upload a directory onto an instance

```sh
gcloud compute scp ./my-source my-instance-name:/home/user/my-source --recurse
```

##### To list available machine types (see also [Machine Types](https://cloud.google.com/compute/docs/machine-types))

```sh
gcloud compute machine-types list
```

##### To list available disk-types

```sh
gcloud compute disk-types list
```

##### To list available VM images

```sh
gcloud compute images list
```

### DNS

##### To list managed zones

```sh
gcloud dns managed-zones list
```

##### To add a managed zone

```sh
gcloud dns managed-zones create test-com --dns-name test.com --description ""
```

##### To describe a zone

```sh
gcloud dns managed-zones describe your-zone-name
```

##### To list all records of a domain

```sh
gcloud dns record-sets list --zone=test-com
```

##### To add a record

```sh
gcloud dns record-sets transaction start --zone=test-com
gcloud dns record-sets transaction add --zone=test-com --ttl 3600 --type A --name office.alexho.dev "192.168.1.1"
gcloud dns record-sets transaction add --zone sbcchk-com --ttl 300 --type MX --name test.com "10 mx1.emailsrvr.com." "20 mx2.emailsrvr.com."
gcloud dns record-sets transaction execute --zone=test-com
```

To abort a transaction

```sh
gcloud dns record-sets transaction abort --zone=test-com
```

### Bucket

##### To copy files recursively

```sh
gsutil cp -R path/to/a/directory gs://your-bucket-name
```

or, with multithreads,

```sh
gsutil -m cp -R path/to/a/directory gs://your-bucket-name
```

##### To create a bucket

```sh
gsutil mb -l asia-east2 -c coldline gs://your-bucket-name
```

##### To serve a website from a bucket directly

Create a `CNAME` DNS record and points it to `c.storage.googleapis.com`.
Noie that it serves traffic in HTTP only (instead of HTTPS).

### IAM

##### Links

- [Permission Reference](https://cloud.google.com/iam/docs/permissions-reference)

##### To list all service accounts

```sh
gcloud iam service-accounts list
```

##### To create service account

```sh
gcloud beta iam service-accounts create --display-name=your-service-account-name your-service-account-name
```

##### To list keys of a service account

```sh
gcloud iam service-accounts keys list --iam-account=your-service-account-name@your-project.iam.gserviceaccount.com
```

##### To create key of service account

To get key in form of `json`

```sh
gcloud iam service-accounts keys create --iam-account=your-service-account-name@your-project.iam.gserviceaccount.com key.json
```

To get key in form of `p12`

```sh
gcloud iam service-accounts keys create --key-file-type=p12 --iam-account=your-service-account-name@your-project.iam.gserviceaccount.com key.p12
```

