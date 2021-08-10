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
gcloud config set core/project $PROJECT_ID
```

##### To get project number from project ID

```sh
gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)'
```

##### To get project ID from project number

```sh
gcloud projects list --filter="project_id:$PROJECT_NUMBER" --format='value(project_id)'
```

### Kubernetes

##### To create a kubernetes cluster

```sh
gcloud container clusters create $CLUSTER_NAME -m n1-standard-2 --num-nodes=3
```

##### To enable network policy (Calico)

```sh
gcloud container clusters update $CLUSTER_NAME --update-addons=NetworkPolicy=ENABLED
gcloud container clusters update $CLUSTER_NAME --enable-network-policy
```

##### To enable workload identity

```sh
gcloud container clusters update $CLUSTER_NAME --workload-pool=$PROJECT_ID.svc.id.goog
gcloud container node-pools update $POOL_NAME --cluster $CLUSTER_NAME --workload-metadata=GKE_METADATA
```

Note that this change will prevent workloads from using the Compute Engine
service account and must be carefully rolled out.

See [Link Kubernetes service account to Google service account](./#link-kubernetes-service-account-to-google-service-account).

##### To set credentials on local machine to access kubernetes clusters

```sh
gcloud container clusters get-credentials $CLUSTER_NAME
```

##### To authenticate to Container Registry on GCP

```sh
gcloud auth configure-docker
```

Note that it can be executed on a GCP compute instance as well

##### To show cluster information

```sh
gcloud container clusters describe $CLUSTER_NAME
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
gcloud container clusters resize $CLUSTER_NAME --size=1
```

##### To migrate workloads to a different machine type

```sh
gcloud container node-pools create new-pool-name \
  --cluster $CLUSTER_NAME \
  --machine-type=f1-micro \
  --num-nodes=10

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do kubectl cordon "$node"; done

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do kubectl drain --force --ignore-daemonsets "$node"; done

gcloud container node-pools delete default-pool --cluster $CLUSTER_NAME
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
kubectl --user=admin/$CLUSTER_NAME create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gc config get-value account)
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

##### Link Kubernetes service account to Google service account

Note that [workload identity has to be enabled](./#to-enable-workload-identity)
before accounts can be linked.

```sh
gcloud iam service-accounts add-iam-policy-binding --role roles/iam.workloadIdentityUser --member "serviceAccount:$PROJECT_ID.svc.id.goog[$NAMESPACE/$SERVICE_ACCOUNT]" $GOOGLE_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com
```

To the Kubernetes service account to bind to, add the following annotation

```yaml
iam.gke.io/gcp-service-account=your_google_service_accont_name@your_project_id.iam.gserviceaccount.com
```

To create a secret and allow a Google service account to access it,

```sh
gcloud secrets create $SECRET_NAME --replication-policy=automatic --data-file=$SECRET_FILE
gcloud secrets add-iam-policy-binding $SECRET_NAME --member=serviceAccount:$GOOGLE_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com --role=roles/secretmanager.secretAccessor
```

To synchronise a secret from GCP Secret Manager to file system of a container,

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1alpha1
kind: SecretProviderClass
metadata:
  name: your-app-secrets
spec:
  provider: gcp
  parameters:
    secrets: |
      - resourceName: "projects/$PROJECT_ID/secrets/testsecret/versions/latest"
        fileName: "secret.txt"
```

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $SERVICE_ACCOUNT
  namespace: $NAMESPACE
  annotations:
    iam.gke.io/gcp-service-account: $GOOGLE_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com
---
apiVersion: v1
kind: Pod
metadata:
  name: mypod
  namespace: default
spec:
  serviceAccountName: $SERVICE_ACCOUNT
  containers:
  - image: your-image:latest
    name: mypod
    volumeMounts:
      - mountPath: "/var/secrets"
        name: mysecret
  volumes:
  - name: mysecret
    csi:
      driver: secrets-store.csi.k8s.io
      readOnly: true
      volumeAttributes:
        secretProviderClass: your-app-secrets
```

##### Unlink Kubernetes service account to Google service account

```sh
gcloud iam service-accounts remove-iam-policy-binding --role roles/iam.workloadIdentityUser --member "serviceAccount:$PROJECT_ID.svc.id.goog[$NAMESPACE/$SERVICE_ACCOUNT]" $GOOGLE_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com
```

### Compute

##### To create an instance

```sh
gcloud compute instances create $INSTANCE_ID --machine-type f1-micro
```

or, with a specific VM image

```sh
gcloud compute instances create $INSTANCE_ID --image-family debian-8 --machine-type f1-micro
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
gcloud compute ssh $USERNAME@$INSTANCE_ID
```

##### SCP

```sh
gcloud compute scp some.txt $INSTANCE_ID:/path/to/the/file
```

or, to copy recursively

```sh
gcloud compute scp some-directory video2:/path/to/a/directory/ --recurse
```

##### To create a persistent volume

```sh
gcloud compute disks create --size 1GB $DISK_NAME
```

##### To list disk provisioned

```sh
gcloud compute disks list
```

##### To delete a disk

```sh
gcloud compute disks delete $DISK_NAME
```

##### To describe a disk

```sh
gcloud compute disks describe $DISK_NAME
```

##### To attach a persistent disk to an instance ([reference](https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting))

```sh
gcloud compute instances attach-disk $INSTANCE_ID --disk $DISK_NAME
```

On the instance,

```sh
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
mkdir my-mount
sudo mount -o discard,defaults /dev/sdb ./my-mount
sudo chmod a+w ./my-mount
sudo chown alex.alex ./my-mount
```

##### To create a custom image from a disk

```sh
gcloud compute images create your_image_name --source-disk=$DISK_NAME --family=debian-10 --storage-location=$ZONE_NAME
```

##### To list instances

```sh
gcloud compute instances list
```

##### To describe an instance

```sh
gcloud compute instances describe $INSTANCE_ID
```

or, to list service accounts and scopes

```sh
gcloud compute instances describe $INSTANCE_ID --format='yaml(serviceAccounts[].scopes[])'
```

##### To delete an instance

```sh
gcloud compute instances delete $INSTANCE_ID
```

##### To upload a directory onto an instance

```sh
gcloud compute scp ./my-source $INSTANCE_ID:/home/user/my-source --recurse
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
gcloud dns managed-zones describe $ZONE_ID
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
gsutil cp -R path/to/a/directory gs://$BUCKET_NAME
```

or, with multithreads,

```sh
gsutil -m cp -R path/to/a/directory gs://$BUCKET_NAME
```

##### To create a bucket

```sh
gsutil mb -l asia-east2 -c coldline gs://$BUCKET_NAME
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
gcloud iam service-accounts create --display-name=$GOOGLE_SERVICE_ACCOUNT $GOOGLE_SERVICE_ACCOUNT
```

##### To list keys of a service account

```sh
gcloud iam service-accounts keys list --iam-account=$GOOGLE_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com
```

##### To create key of service account

To get key in form of `json`

```sh
gcloud iam service-accounts keys create --iam-account=$GOOGLE_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com key.json
```

To get key in form of `p12`

```sh
gcloud iam service-accounts keys create --key-file-type=p12 --iam-account=$GOOGLE_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com key.p12
```

