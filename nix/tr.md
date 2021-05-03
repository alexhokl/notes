
____

##### To transform upper case characters in a string to lower case

```sh
echo Production | tr '[:upper:]' '[:lower:]'
```

##### To convert all files to use lower case file names

```sh
for f in `find`; do mv -v "$f" "`echo $f | tr '[A-Z]' '[a-z]'`"; done
```

##### To remove line feeds in a file

```sh
cat some-file.txt | tr -d "\r\n"
```

The above removes any character of either `\r` or `\n` (not string of `\r\n`).

##### To remove repeating characters to only one

```sh
echo "something      else     okay?" | tr -s ' '
```

The above will produce `something else okay?`.
