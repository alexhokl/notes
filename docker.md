##### Links

-	[Sign an image](https://docs.docker.com/datacenter/dtr/2.4/guides/user/manage-images/sign-images/)
-	[Running Graphical applications in Docker for Mac](https://github.com/chanezon/docker-tips/blob/master/x11/README.md)
-	[Two Weeks with Terraform](https://charity.wtf/2016/02/23/two-weeks-with-terraform/)
-	[kubernetes/kompose](https://github.com/kubernetes/kompose)
-	[Docker Security](https://github.com/docker/labs/tree/master/security)
-	[Jenkins on Kubernetes Engine](https://cloud.google.com/solutions/jenkins-on-kubernetes-engine)
-	[Backup Docker Content Trust Keys](https://docs.docker.com/engine/security/trust/trust_key_mng/#choosing-a-passphrase)
-	[First look: Jenkins CI with Windows Containers and Docker](https://blog.alexellis.io/continuous-integration-docker-windows-containers/)
-	[3 Steps to MSBuild with Docker](https://blog.alexellis.io/3-steps-to-msbuild-with-docker/)
-	[Google Cloud Platform - Storage Options](https://cloud.google.com/images/storage-options/flowchart.svg)

##### Troubleshoot

###### Problem 1

For prompt of

```console
Step 7/7 : COPY ./src .
COPY failed: stat /var/lib/docker/tmp/docker-builder752307336/src: no such file or directory
```

check `.dockerignore` to see if it is a directory being ignored.

###### Problem 2

In case a port could not be exposed, use command `iptables -t nat -nL` to check
if the port in question has been published properly.

##### Commands

###### To stop all containers

```sh
docker stop $(docker ps -a -q)
```

###### To stop and remove all containers

```sh
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```

###### To remove all dangling docker images

```sh
docker system prune
```

###### To remove all docker volumes

```sh
docker volume rm $(docker volume ls -q)
```

###### To copy directory from container to host

```sh
docker cp container-name:/etc/letsencrypt ~/Desktop/letsencrypt
```

###### To inspect the health of a container

Assuming it has `HEALTHCHECK CMD` in the image and the container named `proxy`\)

```sh
docker inspect --format='{{json .State.Health}}' proxy
```

###### To check the network plugins installed on a host

```sh
docker info
```

###### TO check the containers a network is attached to

```sh
docker network inspect your-network-name
```

###### To clean up docker logs (could be deprecated)

```sh
truncate -s 0 /var/lib/docker/containers/*/*-json.log
```

### Dockerfile

##### Best practices

- enable BuildKit `export DOCKER_BUILDKIT=1` (or deamon config `{ "features": { "buildkit": true } }`)
- always combine lines of `apt-get update` and `apt-get install`
- use `apt-get install --no-install-recommends`
- use `rm -rf /var/lib/apt/list/*` to remove files required during installation
- use multi-stage build to enable multi-flavour builds

```dockerfile
ARG FLAVOUR
...

FROM image-name:$FLAVOUR AS some-label
```

- use `RUN --mount` instead of `COPY`
  - `# syntax=docker/dockerfile:1.0-experimental`
  - `RUN --mount=taget=.` instead of `COPY . /app`
  - `RUN --mount=type=cache,taget=/root/.m2`

### Networking

- mappings seen are actually mapping between a port of one end of a bridge to another port of the other side
- overlay network does not really care the subnets under it
- a container in Swarm can be attached to multiple networks whereas a container
    in Kubernetes can only be attached to pod's network (where a pod has only
    one IP)
- every container in Kubernetes can talk to another container and same applies
    to pods
  - separation of containers is done via network policy
  - usually a network policy is applied via labels

### Docker Compose

###### To make sure all containers stated in docker-compose.yml are up and running in daemon mode

```sh
docker-compose up -d
```

###### To make sure all continers stated in docker-compose.yml are stopped, removed and have its network and volumes removed

```sh
docker-compose down -v
```

### Docker Content Trust

Keys of images of docker content trust is stored in `~/.docker/trust/private` and it should be shared among machines. (See [Manage keys for content trust](https://docs.docker.com/engine/security/trust/trust_key_mng/)\)


### Docker Secret

###### To create a secret

```sh
echo "SuperSecret" | docker secret create super_secret -
```

###### To use a secret via commands

```sh
docker service create --name="redis" --secret="super_secret" redis:alpine
```

###### To use a secret via compose

```yml
version: "3.1"
services:
redis:
  image: redis:latest
  deploy:
    replicas: 1
  secrets:
    - super_secret
secrets:
  super_secret:
    external: true
```

and the secret is mounted at `/run/secrets/super_secret`. To use the secret, it usually involves adding or modifying `entrypoint.sh` to read the secret.

### `ENTRYPOINT` vs `CMD`

- At least one of them exists
- `ENTRYPOINT` and `CMD` behaves the same if only of them exist
- For both `CMD` and `ENTRYPOINT`, there are "shell" and "exec" versions
    both shell versions would be prefixed with `/bin/sh -c`
- "exec" version run its process with PID = 1 and "shell" version run its process in a sub-process of a container. Thus, pressing `ctrl-c` would be able to terminate "exec" version but not "shell" version. Note that "exec" version is the recommended way.
-	"exec" version does not have environment variables (like `$PATH`). Thus, to use `java -jar spring.jar`, `["/usr/bin/java", "-jar", "spring.jar"]` is required.
-	If both `ENTRYPOINT` and `CMD` exists and both of them are in "exec" version, it will be chained with `ENTRYPOINT` comes first.
-	If both `ENTRYPOINT` and `CMD` exists and `ENTRYPOINT` is in "exec" version, it will be chained with `ENTRYPOINT` comes first and `CMD` comes after with `/bin/sh -c` prefix.
-	`ENTRYPOINT` and `CMD` can be overridden via command line flags

### Windows

##### Examples

-	[SQL Server Lab](https://github.com/docker/labs/blob/master/windows/sql-server/part-1.md)
- [Manually enable Docker for Windows prerequisites](https://success.docker.com/article/manually-enable-docker-for-windows-prerequisites)

##### Tricks

- Path `/` actually means `C:\\` and `C:/Users/app` means `C:\\Users\\app`
- Avoid using MSI as the uninstallating is not clean

##### Commands

To get IP of a container

```ps1
$ip = docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' a-windows-container-name
```

To run linux containers in Docker Windows container engine (see also [mainfest list](https://docs.docker.com/registry/spec/manifest-v2-2/#manifest-list)\)

```ps1
docker run --platform linux busybox echo hello
```

### Specific images

##### microsoft/mssql-server-linux

Environment variable `attach_dbs` can be used to attached `.mdf` and `.ldf`
files directly.

```json
[
  {
    'dbName': 'MaxDb',
    'dbFiles': ['C:\\temp\\maxtest.mdf',
    'C:\\temp\\maxtest_log.ldf']
  },
  {
    'dbName': 'PerryDb',
    'dbFiles': ['C:\\temp\\perrytest.mdf',
    'C:\\temp\\perrytest_log.ldf']
  }
]
```
