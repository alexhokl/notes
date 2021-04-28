- [Principles](#principles)
- [Examples](#examples)
    + [To show the actual command executed](#to-show-the-actual-command-executed)
    + [Process two tokens at a time](#process-two-tokens-at-a-time)
    + [Basic usages](#basic-usages)
    + [Command substitution](#command-substitution)
    + [Confirmation](#confirmation)
    + [Print substituted command](#print-substituted-command)
____

# Principles

By default, `xargs` takes its input and generate token array where each token is
separated by a space.

# Examples

### To show the actual command executed

```sh
echo "one two three four five" | xargs -t
```

### Process two tokens at a time

```sh
echo "one two three four five" | xargs -n 2
```

and this will output 

```
one two
three four
five
```

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

`%` in both commands represents tokens used in `xargs`

### Confirmation

```sh
find /path -type f -print | xargs -p rm
```

### Print substituted command

```sh
find /path -type f -print | xargs -t rm
```

