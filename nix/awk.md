- [to extract delimited text](#to-extract-delimited-text)
- [to extract certain lines in a file](#to-extract-certain-lines-in-a-file)
- [to find multiple words in a file](#to-find-multiple-words-in-a-file)
- [to do arithmetic](#to-do-arithmetic)
____

### to extract delimited text

```sh
awk -F':' '{ print $1 }' /etc/passwd
```

Note that the default delimiter is space.

### to extract certain lines in a file

```sh
awk '$9 == 500 {print $0} ' /var/log/httpd/access.log
```

```sh
awk '/^Mem:/ { print $3 "/" $2 }'
```

it prints the second and third element of the line started with `Mem:`

### to find multiple words in a file

```sh
awk '/tom|jerry|vivek/' /etc/passwd
```

### to do arithmetic

```sh
awk '{total += $1} END {print total}' earnings.txt
```
