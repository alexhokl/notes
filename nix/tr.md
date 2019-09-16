##### To transform upper case characters in a string to lower case

```sh
echo Production | tr '[:upper:]' '[:lower:]'
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
