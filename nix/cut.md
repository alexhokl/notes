##### To have some parts of a line delimited) by a character

to have part 2 and 4 from a line delimited by a space

```sh
cat file.txt | cut -d ' ' -f 2,4
```

to have all parts except part 2 and 4 from a line delimited by a space

```sh
cat file.txt | cut --complement -d ' ' -f 2,4
```

##### To have all parts of a line after a number of characters

to have all parts of a line except the first 4 characters

```sh
cat file.txt | cut --complement -b 1-4
```

##### To have the parts till the end of the line

```sh
cat file.txt | cut -d ' ' -f 2-
```

The above returns the second element and after.

##### To extract by byte position

```sh
cat file.txt | cut -b 1-4
```

The above will extract the first characters assuming they are all single byte
characters.

##### To replace delimiters

```sh
cat file.txt | cut -d ' ' --output-delimiter=$':' -f 2,4
```
