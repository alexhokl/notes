### Commands

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

###### To check status of pods

```sh
kubectl get pods
```

###### To check if there is a problem in creating a pod

```sh
kubectl describe pod any-pod-name
```

###### To show logs from a pod

```sh
kubectl logs pod-name
```

###### To show only the latest logs from a pod

```sh
kubectl logs pod-name --tail=20
```

###### To stream logs from a pod

```sh
kubectl logs -f pod-name
```

###### To list services deployed (and check external IP exposed)

```sh
kubectl get svc
```

###### To list services in all namespaces

```sh
kubectl get svc --all-namespaces
```

###### To delete a service

```sh
kubectl delete services any-service-name
```

###### To force delete a pod

```sh
kubectl delete pod --grace-period=0 --force my-pod-name
```

###### To create a secret with files to be mounted

```sh
kubectl create secret generic any-secret-name --from-file=path-to-the-filename --from-file=path-to-the-filename2
```

Note that both `path-to-the-filename` and `path-to-the-filename2` will be used
as actual filenames on a mount

###### To create a secret to be used as environment variable

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

###### To get a secret

```sh
kubectl get secret any-secret-name -o yaml
```

###### To get Ingress instances

```sh
kubectl get ingress
```

###### To get deployments

```sh
kubectl get deployments
```

###### To list accessible clusters

```sh
kubectl config get-contexts
```

###### To list all pods and nodes

```sh
kubectl get pod -o=custom-columns=NODE:.spec.nodeName,NAME:.metadata.name --all-namespaces
```

###### To list all major resources

```sh
kubectl get all -o wide --all-namespaces
```

###### To change to access another cluster

```sh
kubectl config use-context a-context-name
```

##### To forward a port from a pod

```sh
kubectl port-forward your-pod-name 8080:80
```

or a using a label

```sh
kubectl port-forward $(kubectl get pod --selector="app=web" --output jsonpath='{.items[0].metadata.name}') 8080:80
```

##### To install Kubernetes Dashboard

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta1/aio/deploy/recommended.yaml
```

### Minikube

##### To start with VirtualBox (default)

```sh
minikube start
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

##### to get IP and port of the running service

```sh
minikube service your-service-name --url --namespace default
```

### Links

- [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- [Configuration Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
- [Web UI (Dashboard)](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
- [kubectl -Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)


