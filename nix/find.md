
____

To avoid issues with root directory, enclose search term with quotes.

##### to find files and directories with name

```sh
find . -name '.git'
```

##### To list files

```sh
find . -name '.git' -ls
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

##### To limit the file size

```sh
find . -type f -size 100c
```

Note that `c` stands for byte, `w` stands for word (2 bytes), `k` stands for
kilo-bytes, `M` stands for mega-bytes and `G` stands for giga-bytes.

##### To find with last modified date

To look for files modified in the last 2 hours

```sh
find . -type f -mmin -120
```

To look for files modified in the last 24 hours

```sh
find . -type f -mtime -1
```

To look for files modified more than 24 hours

```sh
find . -type f -mtime +1
```

##### To replace CRLF (Windows) line-endings with LF (Unix)

On Mac,

```sh
find ./ -type f -exec perl -pi -e 's/\r\n|\n|\r/\n/g' {} \;
```

Or on linux,

```sh
find . -type f -exec grep -qIP '\r\n' {} ';' -exec perl -pi -e 's/\r\n/\n/g' {} '+'
```
