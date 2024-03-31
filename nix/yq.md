- [Recipes](#recipes)
____

## Recipes

##### Update a value

```sh
export IMAGE_NAME=nginx:latest
yq e -i '.spec.containers[0].image = env(IMAGE_NAME)' deployment.yaml
```

