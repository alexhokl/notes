- [Links](#links)
- [Troubleshoot](#troubleshoot)
- [Commands](#commands)
- [Dockerfile](#dockerfile)
  * [Non-root examples](#non-root-examples)
  * [Best practices](#best-practices)
  * [`ENTRYPOINT` vs `CMD`](#entrypoint-vs-cmd)
  * [SHELL](#shell)
- [Networking](#networking)
- [Docker Compose](#docker-compose)
- [Docker Content Trust](#docker-content-trust)
- [Docker Secret](#docker-secret)
- [Docker Swarm](#docker-swarm)
- [Windows](#windows)
- [Specific images](#specific-images)
____

## Links

- [Running Graphical applications in Docker for
  Mac](https://github.com/chanezon/docker-tips/blob/master/x11/README.md)
- [Docker Security](https://github.com/docker/labs/tree/master/security)
- [buildx](https://github.com/docker/buildx)

## Troubleshoot

#### Problem 1

For prompt of

```console
Step 7/7 : COPY ./src .
COPY failed: stat /var/lib/docker/tmp/docker-builder752307336/src: no such file or directory
```

check `.dockerignore` to see if it is a directory being ignored.

#### Problem 2

In case a port could not be exposed, use command `iptables -t nat -nL` to check
if the port in question has been published properly.

#### Problem 3

In case of Docker daemon could not be started, try
`sudo usermod -aG docker $USER`


#### Problem 4

Error message

```
Error response from daemon: failed to create endpoint (...) on network bridge:
failed to add the host (veth1d85371) <=> sandbox (vethbc264f6) pair interfaces:
operation not supported.
```

If this happens after `sudo pacman -Syu`, it is probably about kernel update of
ArchLinux and restarting service of `dockerd` (or restarting machine) should
resolve the problem.

## Commands

##### To logout of a Docker registry

```sh
docker logout docker.io
```

##### To show running containers

```sh
docker ps
```

##### To show all containers

```sh
docker ps -a
```

or, with container size

```sh
docker ps -a -s
```

##### To stop all containers

```sh
docker stop $(docker ps -a -q)
```

##### To stop and remove all containers

```sh
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```

##### To remove all dangling docker images

```sh
docker system prune
```

##### To remove all docker volumes

```sh
docker volume rm $(docker volume ls -q)
```

##### To copy directory from container to host

```sh
docker cp container-name:/etc/letsencrypt ~/Desktop/letsencrypt
```

##### To inspect the health of a container

Assuming it has `HEALTHCHECK CMD` in the image and the container named `proxy`\)

```sh
docker inspect --format='{{json .State.Health}}' your-container-name
```

##### To inspect the port bindings of a container

```sh
docker inspect -f "{{.HostConfig.PortBindings}}" your-container-name
```

##### To check the network plugins installed on a host

```sh
docker info
```

##### To check the containers a network is attached to

```sh
docker network inspect your-network-name
```

##### To create a new tag from an existing image

```sh
docker tag old-image:old-tag new-image:new-tag
```

##### To create an image from a container

```sh
docker commit your-container-name your-image:your-tag
```

##### To check resource consumption of a container

```sh
docker top your-pod-name
```

##### To build with arguments

```sh
docker build --build-arg SOME_VARIABLE=some-value -t your-image:your-tag .
```

##### To remove intermediate container after a successful build

```sh
docker build --rm -t your-image:your-tag .
```

##### To always remove intermediate container after a build

```sh
docker build --force-rm -t your-image:your-tag .
```

##### To build with a different architecture

```sh
docker buildx build --platform=linux/amd64 .
```

Note that the machine has to support this. For instance, Apple M1 Mac support
both `x86` and `arm64`.

##### To stream logs of a container

```sh
docker logs -f your-container-name
```

##### To clean up docker logs (could be deprecated)

```sh
truncate -s 0 /var/lib/docker/containers/*/*-json.log
```

##### To check architecture emulator support

```sh
docker run --rm --privileged tonistiigi/binfmt
```

## Dockerfile

### Non-root examples

- [node](./dockerfiles/node/Dockerfile)
- [nginx](./dockerfiles/nginx/Dockerfile)
- [ASP.NET](./dockerfiles/aspdotnet/Dockerfile)
- From .NET 8, it has user `APP_UID` built-in
  ([example](https://github.com/dotnet/dotnet-docker/blob/e5bc76bca49a1bbf9c11e74a590cf6a9fe9dbf2a/samples/aspnetapp/Dockerfile.alpine-non-root#L27))

### Best practices

- enable BuildKit `export DOCKER_BUILDKIT=1` (or deamon config `{ "features": { "buildkit": true } }`)
- always combine lines of `apt-get update` and `apt-get install`
- use `apt-get install --no-install-recommends package-name`
- use `apk add --no-cache package-name`
- use `rm -rf /var/lib/apt/list/*` to remove files required during installation
  (or `rm /var/cache/apk/*` in alpine)
- use `apk del --purge package-name` to remove a package after it is not being
  used anymore
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
- [Best practices with
  Node.js](https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md)

### `ENTRYPOINT` vs `CMD`

- At least one of them exists
- `ENTRYPOINT` and `CMD` behaves the same if only of them exist
- For both `CMD` and `ENTRYPOINT`, there are "shell" and "exec" versions
  - both shell versions would be prefixed with `/bin/sh -c`
- "exec" version run its process with PID = 1 and "shell" version run its
  process in a sub-process of a container. Thus, pressing `ctrl-c` would be able
  to terminate "exec" version but not "shell" version. Note that "exec" version
  is the recommended way.
- "exec" version does not have environment variables (like `$PATH`). Thus, to
  use `java -jar spring.jar`, `["/usr/bin/java", "-jar", "spring.jar"]` is
  required.
- If both `ENTRYPOINT` and `CMD` exists and both of them are in "exec" version,
  it will be chained with `ENTRYPOINT` comes first.
- If both `ENTRYPOINT` and `CMD` exists and `ENTRYPOINT` is in "exec" version
  and `CMD` is in "shell" version, `CMD` will be chained with `ENTRYPOINT` comes
  first and `CMD` comes after with `/bin/sh -c` prefix.
- If both `ENTRYPOINT` and `CMD` exists and `ENTRYPOINT` is in "shell" version,
  `CMD` will be ignored (and so does arguments passed to `docker run`)
- `ENTRYPOINT` and `CMD` can be overridden via command line flags
  - `ENTRYPOINT` can be overridden by `docker run --entrypoint /bin/sh` or
    similar

### SHELL

- default
  * Linux
    + `["/bin/sh", "-c"]`
  * Windows
    + `["cmd", "/S", "/C"]`
- `SHELL` must be written in JSON ("exec") form
- `SHELL` instruction can appear multiple times in a Dockerfile (effectively it
  is about changing shells)
- `SHELL` of Powershell
  * `["powershell", "-command"]`

## Networking

- use `host.docker.internal` to connect to the host
- mappings seen are actually mapping between a port of one end of a bridge to another port of the other side
- overlay network does not really care the subnets under it
- a container in Swarm can be attached to multiple networks whereas a container
    in Kubernetes can only be attached to pod's network (where a pod has only
    one IP)
- every container in Kubernetes can talk to another container and same applies
    to pods
  - separation of containers is done via network policy
  - usually a network policy is applied via labels
- mounting to `/var/run/docker.sock` enabling a container to connect to Docker
    server API via socket
- [Container Networking Is
  Simple!](https://iximiuz.com/en/posts/container-networking-is-simple/) - not
  particularly on Docker but it explains clearly how container networks can be
  setup using `ip` and `iptables` commands
  - using `docker run --network host` means not network namespace is used
  - with `docker run --network none`, a network namespace is created but no
    bridge will be created (thus, probably useful in case of running a container
    isolated)
  - by default, `docker run --network bridge` is used

## Docker Compose

###### To make sure all containers stated in docker-compose.yml are up and running in daemon mode

```sh
docker-compose up -d
```

###### To compose with specified configuration files

```sh
docker-compose -f docker-compose.yml -f docker-compose.extra.yml up -d
```

###### To make sure all continers stated in docker-compose.yml are stopped, removed and have its network and volumes removed

```sh
docker-compose down -v
```

###### To show logs of a service

```sh
docker-compose logs your-service-name
```

###### To add DNS entries to a container

```yaml
extra_hosts:
- "host.docker.internal:host-gateway"
- "anyip:300:300:300:300"
```

###### To use Cloud Logging on GCP

```yaml
services:
  reverse-proxy:
    image: gcr.io/your-project/haproxy:1.0.0
    ports:
      - "80:80"
      - "443:443"
    logging:
      driver: gcplogs
      options:
        gcp-meta-name:
        labels: some-namespace.app
    labels:
      - "some-namespace.app=reverse-proxy"
```

Reference: [Docker - Google Cloud Logging
driver](https://docs.docker.com/config/containers/logging/gcplogs/)

#### Useful examples

- [Awesome Compose](https://github.com/docker/awesome-compose)

## Docker Content Trust

Keys of images of docker content trust is stored in `~/.docker/trust/private` and it should be shared among machines. (See [Manage keys for content trust](https://docs.docker.com/engine/security/trust/trust_key_mng/)\)


## Docker Secret

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

## Docker Swarm

#### Links

- [Setting up your swarm](https://docs.docker.com/get-started/part4/#set-up-your-swarm)

##### To create a swarm manager

Before creating a swarm manager, one should setup a discovery backend
(discovery token should only be used in development only). See [discovery
backend](https://docs.docker.com/swarm/reference/manage/#discovery--discovery-backend)
for more options.

```sh
docker run -p 4000:4000 -H :4000 --replication --advertise 172.30.0.161:4000 consul://172.30.0.165:8500 -d swarm manage
```

To

```sh
docker run -p 3376:3376 -v /home/ubuntu/.certs:/certs:ro swarm manage --tlsverify --tlscacert=/certs/ca.pem --tlscert=/certs/cert.pem --tlskey=/certs/key.pem --host=0.0.0.0:3376 token://$TOKEN -d swarm manage
```

##### To check the version

```sh
docker run swarm --version
```

##### To start a swarm

```sh
docker swarm init --advertise-addr 192.168.300.300
```

Note that the services will be exposed with IP `192.168.300.300`

##### To show join tokens

for worker,

```sh
docker swarm join-token worker
```

for manager,

```sh
docker swarm join-token manager
```

##### To leave swarm

```sh
docker swarm leave
```

to leave as a manager

```sh
docker swarm leave --force
```

##### To deploy a stack to current swarm

```sh
docker stack deploy -c docker-compose.yml your-stack
```

##### To list running stacks

```sh
docker stack ls
```

##### To list all running services

```sh
docker service ls
```

##### To list running services of a stack

```sh
docker stack services your-stack
```

##### To list containers of a stack

```sh
docker stack ps your-stack
```

##### To show logs of a service

```sh
docker service logs your-stack-service
```

##### To add exposing port to a service

```sh
docker service update --publish-add 30001:80 your-stack-service
```

##### To remove exposing port from a service

```sh
docker service update --publish-rm 30001
```

##### To scale a service

```sh
docker service scale your-stack-service=3
```

##### To remove a stack

```sh
docker stack rm your-stack
```

## Windows

##### Examples

- [SQL Server Lab](https://github.com/docker/labs/blob/master/windows/sql-server/part-1.md)
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

## Specific images

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
