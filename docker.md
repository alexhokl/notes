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
