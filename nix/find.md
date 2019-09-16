###### to find files and directories with name

```sh
find . -name .git
```

###### to find directories with name

```sh
find . -name .git -type d
```

###### to find symlinks with name

```sh
find . -name .git -type l
```

###### to find files with the specified extension

```sh
find . -name '*.sass'
```
