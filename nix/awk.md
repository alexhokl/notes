###### to extract delimited text

```sh
awk -F':' '{ print $1 }' /etc/passwd
```

Note that the default delimiter is space.

###### to extract certain lines in a file

```sh
awk '$9 == 500 {print $0} ' /var/log/httpd/access.log
```

###### to find multiple words in a file

```sh
awk '/tom|jerry|vivek/' /etc/passwd
```

###### to do arithmetic

```sh
awk '{total += $1} END {print total}' earnings.txt
```

