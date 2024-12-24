- [Links](#links)
- [Troubleshooting](#troubleshooting)
  * [error "unable to fetch certificate that owns the secret"](#error-unable-to-fetch-certificate-that-owns-the-secret)
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
  * [Gateway API](#gateway-api)
  * [Ingress class](#ingress-class)
  * [Nginx](#nginx)
- [Credential plugins](#credential-plugins)
  * [Azure](#azure)
  * [Google Cloud](#google-cloud)
- [CLI tools](#cli-tools)
  * [kubectl-view-allocations](#kubectl-view-allocations)
  * [kubectl-whoami](#kubectl-whoami)
  * [goldilocks](#goldilocks)
  * [rbac-lookup](#rbac-lookup)
  * [rabc-tool](#rabc-tool)
  * [nova](#nova)
  * [pluto](#pluto)
- [Security (Hardening Guidance)](#security-hardening-guidance)
  * [Threat model](#threat-model)
  * [Logical components of control plane](#logical-components-of-control-plane)
  * [Worker nodes](#worker-nodes)
  * [PODs](#pods)
  * [Immutable container file systems](#immutable-container-file-systems)
  * [Building secure container images](#building-secure-container-images)
  * [Pod security enforcement](#pod-security-enforcement)
  * [Protecting Pod service account tokens](#protecting-pod-service-account-tokens)
  * [Hardening container environments](#hardening-container-environments)
  * [Network separation and hardening](#network-separation-and-hardening)
  * [Namespaces](#namespaces)
  * [Network policies](#network-policies)
  * [Resource policies](#resource-policies)
  * [Control plane hardening](#control-plane-hardening)
  * [Worker node segmentation](#worker-node-segmentation)
  * [Encryption](#encryption)
  * [Secrets](#secrets)
  * [Authentication](#authentication)
  * [Role-based access control (RBAC)](#role-based-access-control-rbac)
  * [Logging](#logging)
  * [Threat Detection](#threat-detection)
  * [Upgrading and application security practices](#upgrading-and-application-security-practices)
- [Service mesh](#service-mesh)
  * [Advantages](#advantages)
  * [Istio](#istio)
- [Tools](#tools-1)
  * [OpenCost](#opencost)
  * [Postgres](#postgres)
- [GKE](#gke)
  * [Security posture](#security-posture)
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
- [Kubernetes Custom Resource API Reference Docs
  generator](https://github.com/ahmetb/gen-crd-api-reference-docs)

## Troubleshooting

### error "unable to fetch certificate that owns the secret"

Removing an ingress definition does not automatically remove the associated
certificate secret. To resolve this error, remove the certificate secret would
do.

If there is a lot of secret involved, [this
script](https://github.com/richstokes/k8s-scripts/blob/master/clean-orphaned-secrets-cert-manager/clean-orphans.sh)
can be used.

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

##### To list CSI drivers installed on nodes

```sh
kubectl get csinodes -o json | jq '.items[] | {node:.metadata.name, drivers:.spec.drivers[].name}'
```

##### To force releasing a PVC (claim) from a PV

```sh
kubectl patch pv your-pv-name -p '{"spec":{"claimRef": null}}'
```

This is needed when a claim is deleted but the claim attached to PV is not
removed cleanly. Symptoms of this kind of issue can be identified by running
`kubectl describe pvc` and the following warning is shown upon unable to
attached the new claim to the PV.

```
Events:
  Type     Reason         Age   From                         Message
  ----     ------         ----  ----                         -------
  Warning  ClaimMisbound  28s   persistentvolume-controller  Two claims are bound to the same volume, this one is bound incorrectly
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

### Gateway API

- a replacement of `ingress` objects
- [introduction](https://gateway-api.sigs.k8s.io/)

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

## CLI tools

### kubectl-view-allocations

```sh
kubectl view-allocations -r cpu -r memory -g node -n default
```

where it shows CPU and memory allocation used in namespace `default` and grouped
by nodes.

### kubectl-whoami

#### To shows the accounts used to connect to kubernetes

```sh
kubectl whoami
```

#### To shows the information about user, groups and ARN

```sh
kubectl whoami --all
```

To impersonate for an operation

```sh
kubectl whoami --as someone@test.com
```

where the parameter can be a regular user or a service account in a namespace

### goldilocks

Assuming the [standard installation (via
Helm)](https://goldilocks.docs.fairwinds.com/installation/) is made.

Dashboard is available via port-forwarding using the following command

```sh
kubectl port-forward -n goldilocks svc/goldilocks-dashboard 8080:80
```

### rbac-lookup

##### To lookup Kubernetes roles

```sh
rbac-lookup rob --output wide
```

##### To lookup Kubernetes roles filter by kind

```sh
rbac-lookup rob --output wide --kind user
```

##### To lookup Kubernetes roles and its associated GCP roles

```sh
rbac-lookup rob --gke --output wide
```

### rabc-tool

##### To generate RBAC setup of a cluster in HTML

```sh
rbac-tool viz
```

##### To show information of the current login

```sh
rbac-tool whoami
```

##### To list all system subjects and its associated roles and bindings in a cluster

```sh
kub rbac-tool lookup -e '^system:.*'
```

##### To list all policy rules of a subject of a cluster

Policy rules include API group, kind, namespace and verbs

```sh
kub rbac-tool policy-rules -e '^system:authenticated'
```

### nova

##### To find the latest version of Helm charts for update

```sh
nova find --format table
```

### pluto

##### To detect out-dated Kubernetes resources in YAML files in a folder

```sh
pluto detect-files -d deploy/
```

##### To detect out-dated Helm charts in the current cluster

```sh
pluto detect-helm -o wide
```

##### To detect out-dated Kubernetes resources in the current cluster

```sh
pluto detect-api-resources -o wide
```

### ingress2gateway

##### To generate Gateway API resources from Ingress resources

```sh
ingress2gateway --providers ingress-nginx print
```

## Security (Hardening Guidance)

Reference: [Kubernetes Hardening
Guide](https://media.defense.gov/2022/Aug/29/2003066362/-1/-1/0/CTR_KUBERNETES_HARDENING_GUIDANCE_1.2_20220829.PDF)
from National Security Agency (NSA) and Cybersecurity and Infrastructure
Security Agency (CISA)

### Threat model

- supply chain risks
  - container/application level
    - a malicious container or application from a third party could provide
      cyber actors with a foothold in the cluster
  - container runtime
    - mostly referring to OCI runtime since most of stuff based on Docker
  - infrastructure
- malicious threat actors
  - control plane
    - cyber actors frequently take advantage of exposed control plane components
      lacking appropriate access controls
  - worker nodes
    - it hosts the `kubelet` and `kube-proxy` service, which are potentially
      exploitable by cyber actors. Additionally, worker nodes exist outside of
      the locked-down control plane and may be more accessible to cyber actors.
  - containerised applications
    - Applications running inside the cluster are common targets. They are
      frequently accessible outside of the cluster, making them reachable by
      remote cyber actors. An actor can then pivot from an already compromised
      Pod or escalate privileges within the cluster using an exposed
      application’s internally accessible resources.
- insider threats
  - administrator
    - RBAC authorization can reduce the risk by restricting access to sensitive
      capabilities. However, because Kubernetes lacks two-person integrity
      controls, at least one administrative account must be capable of gaining
      control of the cluster.
  - user
    - containerized application users may know and have credentials to access
      containerized services in the Kubernetes cluster
  - cloud service or infrastructure provider

### Logical components of control plane

- Controller manager
- Cloud controller manager
  - An optional component used for cloud-based deployments. The cloud controller
    interfaces with the cloud service provider (CSP) to manage load balancers
    and virtual networking for the cluster
  - usually the default configuration is not secure
- Kubernetes API server
- Etcd
  - it is not intended to be manipulated directly but should be managed through
    the API server
- Scheduler
  - it tracks the status of worker nodes and determines where to run Pods.
    `kube-scheduler` is intended to be accessible only from within the control
    plane.

### Worker nodes

Worker nodes host the following two services that allow orchestration from the
control plane

- `kubelet`
  - runs on each worker node to orchestrate and verify POD execution
- `kube-proxy`
  - a network proxy that users the host's packet filtering capability to ensure
    correct packet routing in the Kubernetes cluster

### PODs

- PODs are often a cyber actor's initial execution environment upon exploiting
  a container
- By default, many container services run as the privileged root user, and
  applications execute inside the container as root despite not requiring
  privileged execution. Preventing root execution by using non-root containers
  or a rootless container engine limits the impact of a container compromise.
  Both methods affect the runtime environment significantly, so applications
  should be thoroughly tested to ensure compatibility.
- non-root containers
  - Container engines allow containers to run applications as a non-root user
    with non-root group membership. Kubernetes can load containers into a Pod
    with `SecurityContext:runAsUser` specifying a non-zero user. While the
    `runAsUser` directive effectively forces non-root execution at deployment,
    It is encouraged that developers to build container applications to execute
    as a non-root user. Having non-root execution integrated at build time
    provides better assurance that applications will function correctly without
    root privileges.
- rootless container engines
  - Some container engines can run in an unprivileged context rather than using
    a daemon running as root. In this scenario, execution would appear to use
    the root user from the containerized application’s perspective, but
    execution is remapped to the engine’s user context on the host.

### Immutable container file systems

Kubernetes can lock down a container’s file system, thereby preventing many
post-exploitation activities. However, these limitations also affect legitimate
container applications and can potentially result in crashes or anomalous
behaviour.

To prevent damaging legitimate applications, Kubernetes administrators can mount
secondary read/write file systems for specific directories where applications
require write access.

```yaml
containers:
- command: ["sleep"]
  args: ["999"]
  image: ubuntu:latest
  name: web
  securityContext:
    readOnlyRootFilesystem: true
  volumeMounts:
  - mountPath: /writeable/location/here
  name: volName
volumes:
- emptyDir: {}
  name: volName
```

### Building secure container images

- use trusted repositories (Docker images) to build containers
- image scanning is key to ensuring deployed containers are secure. Throughout
  the container build workflow, images should be scanned to identify outdated
  libraries, known vulnerabilities, or misconfigurations, such as insecure ports
  or permissions. Scanning should also provide the flexibility to disregard
  false positives for vulnerability detection where knowledgeable cybersecurity
  professionals have deemed alerts to be inaccurate. One approach to
  implementing image scanning is to use an admission controller. An admission
  controller is a Kubernetes-native feature that can intercept and process
  requests to the Kubernetes API prior to persistence of the object, but after
  the request is authenticated and authorized. A custom or proprietary webhook
  can be implemented to scan any image before it is deployed in the cluster.
  This admission controller can block deployments if the image does not comply
  with the organization’s security policies defined in the webhook
  configuration.

### Pod security enforcement

- Pod Security Policies (PSPs)
  - deprecated
  - cluster-wide
- Pod Security Admission is based around categorizing pods as privileged,
  baseline, and restricted and provides a more straightforward implementation
  than PSPs
  - enabled by default in Kubernetes version 1.23

### Protecting Pod service account tokens

- When an application does not need to access the service account directly,
  Kubernetes administrators should ensure that Pod specifications disable the
  secret token being mounted. This can be accomplished using the
  `automountServiceAccountToken: false` directive in the Pod’s YAML
  specification.
- cluster administrators should ensure that RBAC is implemented to restrict Pod
  privileges within the cluster

### Hardening container environments

- hypervisor-backed containerization
  - Hypervisors rely on hardware to enforce the virtualisation boundary rather
    than the operating system. Hypervisor isolation is more secure than traditional container isolation.
- kernel-based solutions
  - The seccomp tool, which is disabled by default, can be used to limit a
    container’s system call abilities, thereby lowering the kernel’s attack
    surface
- application sandboxes

### Network separation and hardening

By default, Kubernetes resources are not isolated and do not prevent lateral
movement or escalation if a cluster is compromised. Resource separation and
encryption can be an effective way to limit a cyber actor’s movement and
escalation within a cluster.

### Namespaces

By default, namespaces are not automatically isolated. However, namespaces do
assign a label to a scope, which can be used to specify authorization rules via
RBAC and networking policies.

User PODs should not be placed in `kube-system` or `kube-public`, as these are
reserved for cluster services.

### Network policies

A Kubernetes `Service` is used to solve the issue of changing IP addresses of
PODs. A `Service` is an abstract way to assign a unique IP address to a logical
set of Pods selected using a label in the Pod configuration.

Services can be exposed externally using `NodePorts` or `LoadBalancers`, and
internally. To expose a `Service` externally, configure the `Service` to use TLS
certificates to encrypt traffic.

Adding `type: NodePort` to the `Service` specification file will assign a random
port to be exposed to the Internet using the cluster’s public IP address. The
`NodePort` can also be assigned manually if desired. Changing the type to
`LoadBalancer` can be used in conjunction with an external load balancer.

Ingress and egress traffic can be controlled with network policies. Network
policies control traffic flow between Pods, namespaces, and external IP
addresses. Once a Pod is selected in a network policy, it rejects any
connections that are not specifically allowed by any applicable policy object.
To create network policies, a container network interface (CNI) plugin that
supports the NetworkPolicy API is required.

Network policy formatting may differ depending on the CNI plugin used for the
cluster. Administrators should use a default policy selecting all Pods to deny
all ingress and egress traffic and ensure any unselected Pods are isolated.
Additional policies could then relax these restrictions for permissible
connections.

External IP addresses can be used in ingress and egress policies using ipBlock,
but different CNI plugins, cloud providers, or service implementations may
affect the order of NetworkPolicy processing and the rewriting of addresses
within the cluster.

### Resource policies

A `LimitRange` policy constrains individual resources per Pod or container
within a particular namespace. Only one `LimitRange` constraint can be created
per namespace.

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-min-max-demo-lr
spec:
  limits
  - default:
      cpu: 1
    defaultRequest:
      cpu: 0.5
    max:
      cpu: 2
    min:
      cpu 0.5
    type: Container
```

`ResourceQuotas` are restrictions placed on the aggregate resource usage for an
entire namespace.

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: example-cpu-mem-resourcequota
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```

Process IDs (PIDs) are a fundamental resource on nodes and can be exhausted
without violating other resource limits. PID exhaustion prevents host daemons
(such as `kubelet` and `kube-proxy`) from running. There are two types of PID
limits and both of them are configured via `kubelet`.

- node PID limits
  - to reserve a specified number of PIDs for system use and Kubernetes system
    daemons
- POD PID limits
  - to limit the number of processes running on each Pod.

Eviction policies can be used to terminate a Pod that is misbehaving and
consuming abnormal resources. However, eviction policies are calculated and
enforced periodically and do not enforce the limit.

### Control plane hardening

It should be highly protected and should not be exposed to the Internet.

Control plane ports

| Protocol | Direction | Port(s)   | Purpose                   |
| ---      | ---       | ---       | ---                       |
| TCP      | Inbound   | 6443      | Kubernetes API server     |
| TCP      | Inbound   | 2379-2380 | `etcd` server client API  |
| TCP      | Inbound   | 10250     | `kubelet` API             |
| TCP      | Inbound   | 10259     | `kube-scheduler`          |
| TCP      | Inbound   | 10257     | `kube-controller-manager` |

`etcd` backend database stores state information and cluster secrets. The `etcd`
server should be configured to trust only certificates assigned to the API
server. `etcd` can be run on a separate control plane node, allowing a firewall
to limit access to only the API servers. Administrators should set up TLS
certificates to enforce Hypertext Transfer Protocol Secure (HTTPS) communication
between the `etcd` server and API servers. Using a separate certificate
authority (CA) for `etcd` may also be beneficial, as it trusts all certificates
issued by the root CA by default.

`$HOME/.kube/` should be protected as it contains credentials.

### Worker node segmentation

Nodes can be divided into two types depending on the PODs it runs.

- external facing
- internal

Firewall could be setup to limit traffic between the two set of nodes.

Ports of nodes

| Protocol | Direction | Port(s)     | Purpose             |
| ---      | ---       | ---         | ---                 |
| TCP      | Inbound   | 10250       | `kubelet` API       |
| TCP      | Inbound   | 30000-32767 | `NodePort` Services |

### Encryption

It should be setup for all traffic in the Kubernetes cluster.

### Secrets

By default, Kubernetes stores secrets as unencrypted base64-encoded strings that
can be retrieved by anyone with API access. Access can be restricted by applying
RBAC policies to the secrets resource. Secrets can be encrypted by configuring
dataat-rest encryption on the API server or by using an external key management
service (KMS), which may be available through a cloud provider. To enable Secret
data-at-rest encryption using the API server.

[Encrypting Secret Data at
Rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
- resources:
  - secrets
  providers:
  - aescbc:
      keys:
      - name: key1
        secret: <base 64 encoded secret>
  - identity: {}
```

Note that restart of API server with flag `--encryption-provider-config` is
required before applying the above resource.

To read existing non-encrypted secrets and encrypt and store,

```sh
kubectl get secrets -A -o json | kubectl replace -f -
```

### Authentication

- service account
  - Authentication is typically managed automatically by Kubernetes through the
    ServiceAccount Admission Controller using bearer tokens. When the admission
    controller is active, it checks whether Pods have an attached service
    account. If the Pod definition does not specify a service account, the
    admission controller attaches the default service account for the
    namespace. Due to bearer tokens are stored as secrets, access to Pod Secrets
    should be restricted to those with a need to view them, using Kubernetes
    RBAC.
- human users
  - Kubernetes does not handle authentication and assumes that a
    cluster-independent service manages user authentication
- Anonymous requests should be disabled by passing the `--anonymous-auth=false`
  option to the API server.

### Role-based access control (RBAC)

- it is enabled by default
- if a cluster is configured to use RBAC and anonymous access is disabled, the
  Kubernetes API server will deny permissions not explicitly allowed
- after a binding is created, the `Role` or `ClusterRole` is immutable. The
  binding must be deleted to change a role.
- privileges assigned to users, groups, and service accounts should follow the
  principle of least privilege, allowing only required permissions to complete
  tasks
- access of different user group should not be overlapped

### Logging

- An effective logging solution and log reviewing are necessary, not only for
  ensuring that services are operating and configured as intended, but also for
  ensuring the security of the system.
- Logging should be performed at all levels of the environment, including on the
  host, application, container, container engine, image registry, api-server,
  and the cloud, as applicable. Once captured, these logs should all be
  aggregated to a single service to provide security auditors, network
  defenders, and incident responders a full view of the actions taken throughout
  the environment.
- some events that administrators should monitor/log
  * API request history
  * Performance metrics
  * Deployments
  * Resource consumption
  * Operating system calls
  * Protocols, permission changes
  * Network traffic
  * Pod scaling
  * Volume mount actions
  * Image and container modification
  * Privilege changes
  * Scheduled job (cronjob) creations and modifications
- When administrators create or update a Pod, they should capture detailed logs
  of the network communications, response times, requests, resource consumption,
  and any other relevant metrics to establish a baseline. RBAC policy
  configurations should also be reviewed periodically and whenever personnel
  changes occur in the organization’s system administrators.
- Audits of internal and external traffic logs should be conducted to ensure all
  intended security constraints on connections have been configured properly and
  are working as intended.
- Streaming logs to an external logging service will help to ensure availability
  to security professionals outside of the cluster, enabling them to identify
  abnormalities in as close to real time as possible. If using this method, logs
  should be encrypted during transit with TLS 1.2 or 1.3 to ensure cyber actors
  cannot access the logs in transit and gain valuable information about the
  environment. Another precaution is to configure append-only access to external
  storage.

#### API server

- Each request, whether generated by a user, an application, or the control
  plane, produces an audit event at each stage in its execution. When an audit
  event registers, the `kube-apiserver` checks for an audit policy file and
  applicable rule. If such a rule exists, the server logs the event at the level
  defined by the first matched rule. Kubernetes’ built-in audit logging
  capabilities perform no logging by default.
- Cluster administrators must write an audit policy YAML file to establish the
  rules and specify the desired audit level at which to log each type of audit
  event. This audit policy file is then passed to the `kube-apiserver` with the
  appropriate flags. For a rule to be considered valid, it must specify one of
  the four audit levels
  * `None`
  * `Metadata`
  * `Request`
  * `RequestResponse`
- Although `RequestResponse` gives all the information for auditing but it could
  involve secrets NSA and CISA recommend reducing the logging level of requests
  involving Secrets to the `Metadata` level to avoid capturing Secrets in logs.
- audit policy
```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
resources:
- group: "" #this refers to the core API group
resources: ["secrets"]
- level: RequestResponse
 # This audit policy logs events involving secrets at the metadata
 # level, and all other audit events at the RequestResponse level
```
- enable audit logging using `kube-apiserver.yaml`
```sh
--audit-policy-file=/etc/kubernetes/policy/audit-policy.yaml
--audit-log-path=/var/log/audit.log
--audit-log-maxage=1825
```
- The logging backend writes the audit events specified to a log file, and the
  webhook backend can be configured to send the file to an external HTTP API.
- The default format for these log files is JSON
- Kubernetes also provides a webhook backend option that administrators can
  manually configure via a YAML file submitted to the `kube-apiserver` to push
  logs to an external backend

#### node and container

- In the built-in method of log management, the `kubelet` on each node is
  responsible for managing logs. It stores and rotates log files locally based
  on its policies for individual file length, storage duration, and storage
  capacity. These logs are controlled by the `kubelet` and can be accessed from
  the command line.
- Pod, or node to die, the native logging solution in Kubernetes does not
  provide a method to preserve logs stored in the failed object. NSA and CISA
  recommend configuring a remote logging solution to preserve logs should a node
  fail.

#### Seccomp: audit mode

- One method for auditing container system calls in Kubernetes is to use the
  seccomp tool. This tool is disabled by default but can be used to limit
  a container’s system call abilities, thereby lowering the kernel’s attack
  surface. Seccomp can also log what calls are being made by using an audit
  profile.
- Logging all system calls can help administrators know what system calls are
  needed for standard operations allowing them to restrict the seccomp profile
  further without losing system functionality. It can also help administrators
  establish a baseline for a Pod’s standard operation patterns, allowing them
  to identify any major deviances from this pattern that could be indicative of
  malicious activity.

#### Syslog

- Kubernetes, by default, writes `kubelet` logs and container runtime logs to
  `journald` if the service is available. If organizations wish to utilize
  `syslog` utilities or to collect logs from across the cluster and forward them
  to a `syslog` server or other log storage and aggregation platform, they can
  configure that capability manually.
- Many Linux operating systems by default use `rsyslog` or `journald` (an event
  logging daemon that optimizes log storage and output logs in `syslog` format
  via `journalctl`).

#### SIEM platform

- Security information and event management (SIEM) software collects logs from
  across an organization’s network.
- SIEM tools have variations in their capabilities. Generally, these platforms
  provide log collection, aggregation, threat detection, and alerting
  capabilities. Some include machine-learning capabilities, which can better
  predict system behaviour and help to reduce false alerts
- Pods and containers are constantly being deleted and redeployed on different
  nodes. This type of environment presents an extra challenge for traditional
  SIEMs, which typically use IP addresses to correlate logs.

#### Service meshes

- Service meshes are platforms that streamline micro-service communications
  within an application by allowing for the logic of these communications to be
  coded into the service mesh rather than within each micro-service. Coding this
  communication logic into individual micro-services is difficult to scale,
  difficult to debug as failures occur, and difficult to secure. Log collection
  at this level can also give cluster administrators insight into the standard
  service-to-service communication flow throughout the cluster.
- functionalities of mesh
  - redirect traffic when a service is down
  - allow management of service-to-service communication encryption
  - collect logs for service-to-service communication
  - help with migrating services to hybrid or multi-cloud environments

#### Fault tolerance

- Another such policy that can be used if logs are being sent to an external
  service is to establish a place for logs to be stored locally if
  a communication loss or an external service failure occurs. Once communication
  to the external service is restored, a policy should be in place for the
  locally stored logs to be pushed up to the external server.

### Threat Detection

- much of the process of log examination can be automated

| Attacker Action | Log Detection |
| --- | --- |
| Attackers may try to deploy a Pod or container to run their own malicious software or to use as a staging ground/pivot point for their attack. Attackers may try to masquerade their deployment as a legitimate image by copying names and naming conventions. They may also try to start a container with root privileges to escalate privileges. | Watch for atypical Pod and container deployments. Use image IDs and layer hashes for comparisons of suspected image deployments against the valid images. Watch for Pods or application containers being started with root permissions |
| Attackers may try to import a malicious image into the victim organization’s registry, either to give themselves access to their image for deployment, or to trick legitimate parties into deploying their malicious image instead of the legitimate ones. | This may be detectable in the container engine or image repository logs. Network defenders should investigate any variations from the standard deployment process. Depending on the specific case this may also be detectible through changes in containers’ behavior after being redeployed using the new image version. |
| If an attacker manages to exploit an application to the point of gaining command execution capabilities on the container, then depending on the configuration of the Pod, they may be able to make API requests from within the Pod, potentially escalating privileges, moving laterally within the
cluster, or breaking out onto the host. | Unusual API requests (from the Kubernetes audit logs) or unusual system calls (from seccomp logs) originating from inside a Pod. This could also show as pod creation requests registering a Pod IP address as its source IP. |
| Attackers who have gained initial access to a Kubernetes cluster will likely start attempting to penetrate further into the cluster, which will require interacting with the `kube-apiserver`. | While they work to determine what initial permissions they have, they may end up making several failed requests to the API server. Repeated failed API requests and request patterns that are atypical for a given account would be red flags. |
| Attackers may attempt to compromise a cluster in order to use the victim’s resources to run their own cryptominer (i.e., a cryptojacking attack). | If an attacker were to successfully start a cryptojacking attack it would likely show in the logs as a sudden spike in resource consumption. |
| Attackers may attempt to use anonymous accounts to avoid attribution of their activities in the cluster | Watch for any anonymous actions in the cluster. |
| Attackers may try to add a volume mount to a container they have compromised or are creating, to gain access to the host | Volume mount actions should be closely monitored for abnormalities. |
| Attackers with the ability to create scheduled jobs (aka Kubernetes CronJobs) may attempt to use this to get Kubernetes to automatically and repetitively run malware on the cluster. | Scheduled job creations and modifications should be closely monitored. |

#### Alerting

- examples of actionable events that could trigger alerts
  * low disk space on any of the machines in the environment
  * available storage space on a logging volume running low
  * external logging service going offline
  * a Pod or application running with root permissions
  * requests being made by an account for resources they do not have permission
    for
  * anonymous requests being submitted to the API server
  * pod or Worker Node IP addresses being listed as the source ID of a Pod
    creation request
  * unusual system calls or failed API calls
  * user/admin behavior that is abnormal (i.e. at unusual times or from an
    unusual location)
  * significant deviations from the standard operation metrics baseline
  * changes to a Pod’s `securityContext`
  * updates to admission controller configs
  * accessing certain sensitive files/URLs

#### Tools

NSA and CISA encourage organizations utilizing Intrusion Detection Systems
(IDSs) on their existing environment to consider integrating that service into
their Kubernetes environment as well. This integration would allow an
organization to monitor for—and potentially kill containers showing signs
of—unusual behavior so the containers can be restarted from the initial clean
image.

### Upgrading and application security practices

- security is an ongoing process, and it is vital to keep up with patches,
  updates, and upgrades
- administrators should adhere to the CIS benchmarks for Kubernetes and any
  other relevant system components
- periodic vulnerability scans and penetration tests should be performed on the
  various system components to proactively look for insecure configurations and
  zero-day vulnerabilities
- as administrators deploy updates, they should also keep up with uninstalling
  any old, unused components from the environment and deployment pipeline.
  * this practice will help reduce the attack surface and the risk of unused
    tools remaining on the system and falling out of date

## Service mesh

### Advantages

- move retries from application to service mesh
- better observation
- it is a software defined network

### Istio

- it can be installed using command `istioctl`
- labeling of deployments are required for Istio to work
- stuff like jaeger or Grafana can be installed as add-ons to Istio
  * to open dashboards
    + `istioctl dashboard grafana`
    + `istioctl dashboard jaeger`
- jaeger has a nicer search UI than Cloud Trace on GCP
- virtual service (an Istio concept) can beapplied over an existing Kubernetes
  to perform actions like automatic API retries

## Tools

### OpenCost

- [opencost/opencost](https://github.com/opencost/opencost)
- [documentation](https://www.opencost.io/docs/)

### Postgres

- [StackGres](https://stackgres.io/)
  - it provides a Helm chart for deploying Postgres on Kubernetes
  - it provides connection pooling, automatic failover and HA, monitoring,
    backups and DR, centralized logging
  - components
    * PostgreSQL
      + The world’s most advanced open source relational database
    * Patroni
      + The HA solution that relies on kubernetes distributed consensus storage to
    * WAL-G
      + WAL-G is an archival restoration tool for Postgres
    * PgBouncer
      + Lightweight connection pooler for PostgreSQL
    * PostgreSQL Server Exporter
      + Prometheus exporter for PostgreSQL server metrics.
    * Envoy
      + open source edge and service proxy, designed for cloud-native applications
  - it provides a Web UI for managing Postgres instances

### Application Identity management

- [keycloak](https://keycloak.org) - including SAML, OpenID Connect, OAuth 2.0,
  LDAP and social login; implementing a custom provider is required if
  a relational database is used

## GKE

### Security posture

- it requires enabling of Container Security API
- it includes sustained scanning and assessment of workloads and container
  images

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
