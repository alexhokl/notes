```sh
find /path -type f -print | xargs rm
```

and it is equivalent to `rm $(find /path -type f)`

or, for another example

```sh
kubectl get pods --all-namespaces | grep Evicted | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod
```

###### command substitution

```sh
find /path -type f -name '*~' -print0 | xargs -0 -I % cp -a % ~/backups
```
