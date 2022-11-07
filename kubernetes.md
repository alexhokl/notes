- [Links](#links)
- [Commands](#commands)
- [Resource Definitions](#resource-definitions)
  * [Sidecars](#sidecars)
  * [Resource quota](#resource-quota)
  * [Security](#security)
  * [Network policy](#network-policy)
- [Concepts](#concepts)
  * [Operator pattern](#operator-pattern)
  * [Daemonset](#daemonset)
  * [Statefulset](#statefulset)
  * [Termination](#termination)
  * [Readiness and liveness](#readiness-and-liveness)
  * [RBAC and sudo](#rbac-and-sudo)
- [API](#api)
- [Ingress](#ingress)
  * [Ingress class](#ingress-class)
  * [Nginx](#nginx)
- [Credential plugins](#credential-plugins)
  * [Azure](#azure)
  * [Google Cloud](#google-cloud)
- [References](#references)
- [kind](#kind)
- [Minikube](#minikube)
  * [Secret Management](#secret-management)
____

## Links

- [Kubernetes Resource Report](https://github.com/hjacobs/kube-resource-report)
- [GoogleContainerTools/kpt](https://github.com/GoogleContainerTools/kpt)
- [DNS for Services and
  Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- [Configuration Best
  Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Kubernetes The Hard
  Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) [Web UI
  (Dashboard)](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
- [kubectl -Cheat
  Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Spinnaker](https://www.spinnaker.io/) - an open-source, multi-cloud
  continuous delivery platform that helps you release software changes with
  high velocity and confidence
- [A visual guide on troubleshooting Kubernetes
  deployments](https://learnk8s.io/troubleshooting-deployments)
- [OperatorHub.io](https://operatorhub.io/)
- [Nginx Ingress](https://kubernetes.github.io/ingress-nginx/)
  - [Troubleshooting - NGINX Ingress
    Controller](https://kubernetes.github.io/ingress-nginx/troubleshooting/)
  - [Nginx Ingress controller -
    Annotations](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/)
  - [Nginx Ingress controller -
    ConfigMap](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/)
- [sighupio/permission-manager](https://github.com/sighupio/permission-manager)
- [Troubleshooting
  cert-manager](https://cert-manager.io/docs/faq/troubleshooting/)
- [kubectl
  plugins](https://github.com/kubernetes-sigs/krew-index/blob/master/plugins.md)
- [Awesome Kubernetes
  Resources](https://github.com/tomhuang12/awesome-k8s-resources)
- [kubescape/kubescape](https://github.com/kubescape/kubescape) - a CLI tool to
  scan Kubernetes cluster using a specific industry standard and produce
  a report

## Commands

##### To add docker login to the current kubernetes cluster

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

##### To create deployment or service to the current cluster (where `directory-to-files` contains the YAML files of deployments, and/or services, etc)

```sh
kubectl create -f directory-to-files/
```

##### To delete pods from configuration files (`.json` or `.yaml`)

```sh
kubectl delete -f directory-to-files/
```

##### To apply a configuration from a file

```sh
kubectl apply -f some-config.yml
```

##### To show current cluster information

```sh
kubectl cluster-info
```

##### To list API versions

```sh
kubectl api-version
```

##### To show kubectl config

Effectively showing `.kube/config`.

```sh
kubectl config view
```

##### To list accessible clusters

```sh
kubectl config get-contexts
```

##### To change to access another cluster

```sh
kubectl config use-context a-context-name
```

##### To show only the latest logs from a pod

```sh
kubectl logs pod-name --tail=20
```

##### To stream logs from a pod

```sh
kubectl logs -f pod-name
```

##### To force delete a pod

```sh
kubectl delete pod --grace-period=0 --force my-pod-name
```

##### To create a secret with files to be mounted

```sh
kubectl create secret generic any-secret-name --from-file=mounted-name1=/local/path/filename --from-file=mounted-name2=/local/path/filename2
```

##### To create a secret with plain text

```sh
kubectl create secret generic any-secret-name --from-literal=username=alice --from-literal=password=bob-does-not-know
```

##### To create a secret to be used as environment variable

```sh
echo -n 'somesecret' | base64
```

Copy the base64 representation to a `yaml` file

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: any-secret-name
type: Opaque
data:
  any-secret-env-var-name: YWRtaW4=
```

```sh
kubectl apply -f secret.yml
```

##### To get a secret

```sh
kubectl get secret any-secret-name -o yaml
```

##### To list names of pods in the current namespace

```sh
kubectl get pod -o=name
```

##### To list all pods and nodes

```sh
kubectl get pod -o=custom-columns=NODE:.spec.nodeName,NAME:.metadata.name --all-namespaces
```

##### To forward a port from a pod

```sh
kubectl port-forward your-pod-name 8080:80
```

or, using a label

```sh
kubectl port-forward $(kubectl get pod --selector="app=web" --output jsonpath='{.items[0].metadata.name}') 8080:80
```

or, using a service name

```sh
kubectl port-forward service/your-service 8080:80
```

##### To delete all evicted pods

```sh
kubectl get pods --all-namespaces | grep Evicted | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod
```

##### To install Kubernetes Dashboard

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta1/aio/deploy/recommended.yaml
```

##### To port forward Kubernetes Dashboard

```sh
kubectl port-forward $(kubectl get pods --selector=k8s-app=kubernetes-dashboard -o jsonpath='{.items[0].metadata.name}') 5000:8443
```

##### To copy a file into a pod

```sh
kubectl cp some-file your-pod-name:/some/path/
```

##### To execute a command in a pod

```sh
kubectl exec -it your-pod-name -- ls -l
```

##### To cordon a node

```sh
kubectl cordon your-node-name
```

##### To drain pods in a node

```sh
kubectl drain your-node-name --ignore-daemonsets
```

##### To check current performance

of nodes

```sh
kubectl top node
```

or, of pods

```sh
kubectl top pod
```

or, of containers

```sh
kubectl top pod --containers
```

##### To show endpoints

```sh
kubectl get endpoints
```

or,

```sh
kubectl get ep
```

This gives information about endpoints used by services and whether the
endpoints are healthy.

##### To create a job from existing cronjob definition

```sh
kubectl create job --from=cronjob/your-cronjob-name your-new-job-name
```

##### To SSH into a node (with a SSH key already been setup on the node)

```sh
kubectl node-shell your-node-name
```

where `node-shell` is a `krew` plugin and `your-node-name` get be retrieved by
`kubectl get nodes`

or without using a plugin,

See [To SSH into one of the
nodes](https://github.com/alexhokl/notes/blob/master/azure-cli.md#to-ssh-into-one-of-the-nodes)
for steps to prepare a SSH key on Azure.

Create a container in the cluster and prepare tools and directories.

```sh
kubectl run --rm -it aks-ssh --image=debian
mkdir ~/.ssh
apt update && apt install -y openssh-client
```

Open a new terminal and copy the SSH private key into the container.

```sh
kubectl cp ~/.ssh/already-setup-key $(kubectl get pod -l run=aks-ssh -o jsonpath='{.items[0].metadata.name}'):/root/.ssh/id_rsa
kubectl get nodes -o wide
```

Copy the IP address of the node that we will SSH into and return to the
original terminal.

```sh
chmod 0600 ~/.ssh/id_rsa
ssh azureuser@10.240.0.4
```

##### To check if a Kubernetes cluster is deployed securely

```sh
kubectl apply -f https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job.yaml
```

## Resource Definitions

### Sidecars

##### To add a sidecar container to pump logs to pump logs to stdout

Add an empty directory to `volumes` of a `deployment` definition.

```yaml
volumes:
- name: log
    emptyDir: {}
```

Mount the directory to the target container

```yaml
volumeMounts:
- name: log
  mountPath: /var/log
```

Finally, add the sidecar container to `deployment` definition.

```yaml
- name: logger
  image: docker.io/bash:latest
  volumeMounts:
    - name: log
      mountPath: /tmp/log
  command:
    - "/bin/sh"
    - "-c"
    - "tail -f /tmp/log/vsftpd.log"
```

### Resource quota

##### To add resource quota to a namespace

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: your-quota-name
  namespace: your-namespace
spec:
  hard:
    services: "1"
    pods: "3"
    request.cpu: "2"
    request.memory: 1Gi
    limits.cpu: "4"
    limits.memory: 2Gi
```

### Security

##### To run as a non-root user

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      securityContext:
        fsGroup: 101
      containers:
        - name: web
          image: nginx:1.19-alpine
          ports:
            - name: http-port
              containerPort: 8080
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            runAsGroup: 101
            runAsNonRoot: false
            runAsUser: 101
```

Note that `readOnlyRootFilesystem` may not work if the container requires write
access to `/tmp/`.

Use `fsGroup` for mounted volumes. The mounted volume will have
ownership as user `root` and group `GID` (assigned to ID set as `fsGroup`).

By default, Kubernetes recursively changes ownership and permissions for the
contents of each volume to match the `fsGroup` specified in a Pod's
`securityContext` when that volume is mounted. For large volumes, checking and
changing ownership and permissions can take a lot of time, slowing Pod startup.
`fsGroupChangePolicy` can be set as `OnRootMisatch` (and the default is `Always`
to only change permissions and ownership if permission and ownership of root
directory does not match with expected permissions of the volume. Note that this
field has no effect on ephemeral volume types such as `secret`, `configMap` and
`emptydir`.

Note that the ID has to match the user or group created within `Dockerfile`.

If `runAsGroup` is not assigned, it will be assigned with `0` (root).

To check the current `uid` used.

```sh
kubectl exec -it container-name -- id
```

See [Non-root examples in
Docker](https://github.com/alexhokl/notes/blob/master/docker.md#non-root-examples).

##### To add Linux capabilities

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo-4
spec:
  containers:
  - name: web
    image: nginx:1.19-alpine
    securityContext:
      capabilities:
        add: ["NET_ADMIN", "SYS_TIME"]
```

This adds `CAP_NET_ADMIN` and `CAP_SYS_TIME` capabilities. Note that when you
list capabilities in your container manifest, you must omit the `CAP_` portion
of the constant.

See [capabilities](https://man7.org/linux/man-pages/man7/capabilities.7.html).

##### To set seccomp profile

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo-4
spec:
  containers:
  - name: web
    image: nginx:1.19-alpine
    securityContext:
      seccompProfile:
        type: RuntimeDefault
```

The above configuration sets the Seccomp profile to the node's default profile.

Valid values of `type` are `RuntimeDefault`, `Unconfined` and `Localhost`.

`localhostProfile` must be set if type is `localhost` and it allows a profile
can be pre-configured on a node.

```yaml
securityContext:
  seccompProfile:
    type: Localhost
    localhostProfile: my-profiles/profile-allow.json
```

##### To assign SELinux match

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo-4
spec:
  containers:
  - name: web
    image: nginx:1.19-alpine
    securityContext:
      seLinuxOptions:
        level: "s0:c123,c456"
```

To assign SELinux labels, the SELinux security module must be loaded on the host
operating system.

SELinux is about supporting access control security policies, including
mandatory access controls (MAC).

Note that, after you specify an MCS label for a Pod, all Pods with the same
label can access the Volume. If you need inter-Pod protection, you must assign
a unique MCS label to each Pod.

### Network policy

##### To deny all but incoming traffic to a port

It is a best practice to start with a policy denying all traffic first. The
following has a policy to set such default and another policy to allow
a specific traffic.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: your-namespace
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: web
  namespace: your-namespace
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
  ingress:
  - from:
    ports:
    - protocol: TCP
      port: 8080
```

Reference: [Get started with Kubernetes network
policy](https://projectcalico.docs.tigera.io/security/kubernetes-network-policy)

If no Kubernetes network policies apply to a pod, then all traffic to/from the
pod are allowed. If one or more Kubernetes network policies apply to a pod, then
only the traffic specifically defined in that network policy are allowed.

To allow ingress traffic from `kube-system` namespace, apply the following
command and network policy.

```sh
kubectl label namespace kube-system name=kube-system
```

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-kube-system-access
  namespace: demo
spec:
  podSelector:
    matchLabels: {}
  policyTypes:
  - Ingress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: kube-system
    ports:
    - protocol: TCP
      port: 8080
```

## Concepts

### Operator pattern

- Operators are clients of the Kubernetes API that act as controllers for
  a custom resource.
- The most common way to deploy an Operator is to add the Custom Resource
  Definition and its associated Controller to your cluster. The Controller will
  normally run outside of the control plane, much as you would run any
  containerized application. For example, you can run the controller in your
  cluster as a Deployment.
- Assuming operator of custom resource `SampleDB` has been deployed, to apply
  new changes to the resource, simply use `kubectl edit
  SampleDB/example-database`.

### Daemonset

- The way to install a single something on every machine. Kubernetes will
  ensure there is only one instance on every machine and restart it if
  necessary.

### Statefulset

It is valuable for applications that require one or more of the following

- Stable, unique network identifiers
  - pod name
    - `$(statefulset name)-$(ordinal)`
    - `$(podname).$(governing service domain)`
  - service name
    - `$(service name).$(namespace).svc.cluster.local`
- Stable, persistent storage
  - by using `VolumeClaimTemplate`
  - the `PersistentVolume`s associated with the Pods’ `PersistentVolume` Claims
    are not deleted when the Pods, or `StatefulSet` are deleted. This must be
    done manually.
- Ordered, graceful deployment and scaling
- Ordered, automated rolling updates

### Termination

The container runtime sends a `TERM` signal is sent to the main process in each
container. Once the grace period (default is 30 seconds) has expired, the `KILL`
signal is sent to any remaining processes, and the Pod is then deleted from the
API Server.

`kubelet` tries to run a graceful shutdown during the grace period. `kubelet`
runs `preStop` hook if there is one defined. `kubelet` then triggers the
container runtime to send a `TERM` signal to process `1` inside each container
of the POD.

At the same time as the `kubelet` is starting graceful shutdown, the control
plane removes that shutting-down Pod from `Endpoint`s (and, if enabled,
`EndpointSlice`). Since it takes a while for the `Endpoint` to be removed, it
means traffic will still be directed to the POD. Thus, it is best to add
a `preStop` hook to delay the triggering of `TERM` signal. This ensures that the
POD will not be receiving new traffic by the time is starts termination.

```yaml
spec:
  containers:
    lifecycle:
      preStop:
        exec:
          command:
            - /bin/sleep
            - "15"
```

### Readiness and liveness

- readiness
  - failing means no traffic will be sent to the POD by Kubernetes and this is
    not only applied at start-up of the container
- liveness
  - failing multiple time (depends on configuration) means Kubernetes will start
    the POD

### RBAC and sudo

Reference: [Least Privilege in Kubernetes Using
Impersonation](https://johnharris.io/2019/08/least-privilege-in-kubernetes-using-impersonation/)

Although administrators can grant themselves role `cluster-admin`, we may not
want administrators to use such a role all the time to avoid mistakes which
could be damaging. `sudo`-like way of executing a `kubectl` command is possible
through the use of option `--as`, such as `--as cluster-admin`. To achieve this,
we assign administrators with less privileged roles (or even read-only roles)
but we also assign them with a role where they can impersonate as
`cluster-admin`. The following is setup of such role and role binding (where
`ops-team` is the group administrators are assigned to).

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-admin-impersonator
rules:
- apiGroups: [""]
  resources: ["users"]
  verbs: ["impersonate"]
  resourceNames: ["cluster-admin"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-admin-impersonate
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin-impersonator
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: ops-team
```

## API

##### To setup shell

```sh
SERVICE_ACCOUNT_NAME=default
SERVICE_ACCOUNT_SECRET_NAME=$(kubectl get serviceaccount -n default ${SERVICE_ACCOUNT_NAME} -o json | jq -Mr '.secrets[].name | select(contains("token"))')
SERVICE_ACCOUNT_TOKEN=$(kubectl view-secret -n default $SERVICE_ACCOUNT_SECRET_NAME token)
kubectl view-secret -n default $SERVICE_ACCOUNT_SECRET_NAME ca.crt > /tmp/ca.crt
API_URL=$(kubectl -n default get endpoints kubernetes -o json | jq -r '(.subsets[0].addresses[0].ip + ":" + (.subsets[0].ports[0].port|tostring))')
```

##### To get nodes

```sh
curl -sk https://$API_URL/api/v1/nodes -H "Authorization: Bearer ${SERVICE_ACCOUNT_TOKEN}" --cacert /tmp/ca.crt
```

##### To get admin-user token

```sh
SERVICE_ACCOUNT_NAME=admin-user
SERVICE_ACCOUNT_SECRET_NAME=$(kubectl get serviceaccount -n kube-system ${SERVICE_ACCOUNT_NAME} -o json | jq -Mr '.secrets[].name | select(contains("token"))')
SERVICE_ACCOUNT_TOKEN=$(kubectl view-secret -n kube-system $SERVICE_ACCOUNT_SECRET_NAME token)
```

## Ingress

### Ingress class

`kubernetes.io/ingress.class: nginx` or `kubernetes.io/ingress.class: haproxy`
should be used to define the ingress controller to be used. Otherwise, on GCP,
a load balancer will be created per ingress which can be very expensive.

### Nginx

##### HTTP response 413 (Request entity too large)

We can get around this problem by changing the value of Nginx configuration
`client-max-body`. If Helm chart is used, the value can be set to
`controller.config.proxy-body-size`. It can also be set via annotation
`nginx.ingress.kubernetes.io/proxy-body-size` of the Ingress resource.

## Credential plugins

### Azure

Download [kubelogin](https://github.com/Azure/kubelogin) and run `kubelogin
convert-kubeconfig -l azurecli` to convert existing entries in `~/.kube/config`
to use `azure-cli` to retrieve access token.

### Google Cloud

```sh
yay -S google-cloud-sdk-gke-gcloud-auth-plugin
```

If version of Kubernetes is lower than `v1.25`, use `export
USE_GKE_GCLOUD_AUTH_PLUGIN=True`.

or, on Windows or Mac,

```sh
gcloud components install gke-gcloud-auth-plugin
```

## References

- [Kubernetes Custom Resource API Reference Docs
  generator](https://github.com/ahmetb/gen-crd-api-reference-docs)

## kind

##### To create a cluster with ingress and Docker registry

```sh
curl -sSL https://raw.githubusercontent.com/alexhokl/notes/master/shell_scripts/create_kind_cluster.sh | bash -
```

- [Link to
  script](https://github.com/alexhokl/notes/blob/master/shell_scripts/create_kind_cluster.sh)
- [Link to yaml used by the
  script](https://github.com/alexhokl/notes/master/yaml/kind-cluster.yml)

To push an image to the Docker registry used by kind,
(assuming the image is named `test:1.0`)

```sh
docker tag test:1.0 localhost::5000/test:1.0
docker push localhost::5000/test:1.0
```

Note that the image name used in deployment should also be
`localhost::5000/test:1.0`.

##### Configuration

- Each `role` corresponds to a cluster node
- To make a host volume available as persistent volume, use
  [`extraMounts`](https://kind.sigs.k8s.io/docs/user/configuration/#extra-mounts)

## Minikube

##### To start with VirtualBox (default)

```sh
minikube start
```

##### To start with kvm2

```sh
minikube start --driver=kvm2
```

##### To start with a local mount

```sh
minikube start --mount-string=/home/user/something:/data --mount
```

It compliments with

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - image: nginx:0.1
    name: nginx
    volumeMounts:
    - mountPath: /mnt/data
      name: volume
  volumes:
  - name: volume
    hostPath:
      path: /data
```

##### To start with a larger VM disk

```sh
minikube start --disk-size=100GB
```

Note that the default is 16GB.
Also note that `minikube delete` is required before starting with a new disk
size.

##### To change the default driver

```sh
minikube config set driver kvm2
```

##### To change default memory limit

```sh
minikube config set memory 8192
```

##### To change default CPU limit

```sh
minikube config set cups 4
```

##### To stop

```sh
minikube stop
```

##### To check the status

```sh
minikube status
```

##### To delete the default cluster

```sh
minikube delete -p minikube
```

##### To show Kubernetes Dashboard

```sh
minikube dashboard
```

##### To enable access to local docker registry

```sh
eval $(minikube docker-env)
```

##### To add NGINX ingress controller

```sh
minikube addons enable ingress
```

##### To get IP and port of the running service

```sh
minikube service your-service-name --url --namespace default
```

##### To SSH into the VM

```sh
minikube ssh -- df -h
```

### Secret Management

##### KMS Plugins

- [googlecloudplatform/k8s-cloudkms-plugin](https://github.com/googlecloudplatform/k8s-cloudkms-plugin)
- [azure/kubernetes-kms](https://github.com/azure/kubernetes-kms)
- [kubernetes-sigs/aws-encryption-provider](https://github.com/kubernetes-sigs/aws-encryption-provider)
- [oracle/kubernetes-vault-kms-plugin](https://github.com/oracle/kubernetes-vault-kms-plugin)
