
____

##### symbolic link

```sh
ln -s /path/to/target /path/to/link
```

to remove the file if it exists in the path of the link

```sh
ln -sf /path/to/target /path/to/link
```

to treat the link as a normal file

```sh
ln -sn /path/to/target /path/to/link
```
