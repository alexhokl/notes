- [Basic usages](#basic-usages)
- [Command substitution](#command-substitution)
- [Confirmation](#confirmation)
- [Print substituted command](#print-substituted-command)
____

### Basic usages

```sh
find /path -type f -print | xargs rm
```

and it is equivalent to `rm $(find /path -type f)`

or, for another example

```sh
kubectl get pods --all-namespaces | grep Evicted | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod
```

### Command substitution

```sh
find /path -type f -name '*~' -print0 | xargs -0 -I % cp -a % ~/backups
```

```sh
cat list | xargs -I % echo "print % done"
```

### Confirmation

```sh
find /path -type f -print | xargs -p rm
```

### Print substituted command

```sh
find /path -type f -print | xargs -t rm
```
