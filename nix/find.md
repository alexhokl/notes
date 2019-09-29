To avoid issues with root directory, enclose search term with quotes.

##### to find files and directories with name

```sh
find . -name '.git'
```

##### to find directories with name

```sh
find . -name '.git' -type d
```

##### To list all sub-directories

```sh
find . -type d
```

##### to find symlinks with name

```sh
find . -name '.git' -type l
```

##### to find files with the specified extension

```sh
find . -name '*.sass'
```

##### To negate any conditions

```sh
find . -not -name '*.orig'
```

##### To delete found files

```sh
find . -name '*.orig' -delete
```

##### To exec a command with found files

```sh
find . -name '*.orig' -exec rm {} \;
```

##### To find using multiple filters (AND)

```sh
find . -name '*.md' -name 'README.*'
```

##### To limit the depth of search

```sh
find . -name '*.json' -maxdepth 2
```

