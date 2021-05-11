- [Links](#links)
- [Commands](#commands)
- [Resource Definitions](#resource-definitions)
- [Concepts](#concepts)
  * [Operator pattern](#operator-pattern)
  * [Daemonset](#daemonset)
  * [Statefulset](#statefulset)
  * [Termination](#termination)
- [API](#api)
- [References](#references)
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
- [sighupio/permission-manager](https://github.com/sighupio/permission-manager)
- [Troubleshooting
  cert-manager](https://cert-manager.io/docs/faq/troubleshooting/)
- [kubectl
  plugins](https://github.com/kubernetes-sigs/krew-index/blob/master/plugins.md)

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

##### To create a job from existing cronjob definition

```sh
kubectl create job --from=cronjob/your-cronjob-name your-new-job-name
```

##### To SSH into a node (with a SSH key already been setup on the node)

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

## Resource Definitions

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

Use `fsGroup` if there are mounted volumes. The mounted volume will have
ownership as user `root` and group `GID` (assigned to ID set as `fsGroup`).

Note that the ID has to match the user or group created within `Dockerfile`.

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

This adds `CAP_NET_ADMIN` and `CAP_SYS_TIME` capabilities.

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

This set the Seccomp profile to the node's container run default profile.

Note that profile can be pre-configured on a node.

```yaml
securityContext:
  seccompProfile:
    type: Localhost
    localhostProfile: my-profiles/profile-allow.json
```

##### To deny all but incoming traffic to a port

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

## References

- [Kubernetes Custom Resource API Reference Docs
  generator](https://github.com/ahmetb/gen-crd-api-reference-docs)

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
