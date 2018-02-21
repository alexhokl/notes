##### Links

- [Sign an image](https://docs.docker.com/datacenter/dtr/2.4/guides/user/manage-images/sign-images/)

##### Troubleshoot

For prompt of

```console
Step 7/7 : COPY ./src .
COPY failed: stat /var/lib/docker/tmp/docker-builder752307336/src: no such file or directory
```

check `.dockerignore` to see if it is a directory being ignored.

##### Commands

to stop all containers
```sh
docker stop $(docker ps -a -q)
```

to stop and remove all containers
```sh
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```

to remove all dangling docker images
```sh
docker rmi $(docker images -q --filter "dangling=true")
```

to remove all docker volumes
```sh
docker volume rm $(docker volume ls -q)
```

to copy directory from container to host
```sh
docker cp proxy:/etc/letsencrypt ~/Desktop/letsencrypt
```

To inspect the health of a container (assuming it has `HEALTHCHECK CMD` in the image and the container named `proxy`)
```sh
docker inspect --format='{{json .State.Health}}' proxy
```

to make sure all containers stated in docker-compose.yml are up and running in daemon mode
```sh
docker-compose up -d
```

to make sure all containers stated in docker-compose.yml are stopped, removed and have its network and volumes removed
```sh
docker-compose down -v
```

to clean up docker logs
```sh
truncate -s 0 /var/lib/docker/containers/*/*-json.log
```

Keys of images of docker content trust is stored in `~/.docker/trust/private`
and it should be shared among machines. (See [Manage keys for content trust](https://docs.docker.com/engine/security/trust/trust_key_mng/))

##### Secret

To create a secret

```sh
echo "SuperSecret" | docker secret create super_secret -
```

To use a secret via commands

```sh
docker service create --name="redis" --secret="super_secret" redis:alpine
```

To use a secret via compose

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

##### `ENTRYPOINT` vs `CMD`

- At least one of them exists
- `ENTRYPOINT` and `CMD` behaves the same if only of them exist
- For both `CMD` and `ENTRYPOINT`, there are "shell" and "exec" versions
  - both shell versions would be prefixed with `/bin/sh -c`
- "exec" version run its process with PID = 1 and "shell" version run its process in a sub-process of a container. Thus, pressing `ctrl-c` would be able to terminate "exec" version but not "shell" version. Note that "exec" version is the recommended way.
- "exec" version does not have environment variables (like `$PATH`). Thus, to use `java -jar spring.jar`, `["/usr/bin/java", "-jar", "spring.jar"]` is required.
- If both `ENTRYPOINT` and `CMD` exists and both of them are in "exec" version, it will be chained with `ENTRYPOINT` comes first.
- If both `ENTRYPOINT` and `CMD` exists and `ENTRYPOINT` is in "exec" version, it will be chained with `ENTRYPOINT` comes first and `CMD` comes after with `/bin/sh -c` prefix.
- `ENTRYPOINT` and `CMD` can be overridden via command line flags

### Windows

##### Examples

- [SQL Server Lab](https://github.com/docker/labs/blob/master/windows/sql-server/part-1.md)

##### Commands

To get IP of a container

```console
$ip = docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' a-windows-container-name
```

To run linux containers in Docker Windows container engine

```console
docker run --platform linux busybox echo hello
```
