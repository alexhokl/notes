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
