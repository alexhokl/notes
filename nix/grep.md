
____

##### To find multiple terms

```sh
grep "term1\|term2" some.txt
```

##### To find files with a wording and a particular extension

```sh
grep search-term -r --include \*.{html,js} app/directory
```

##### To search for hidden files

```sh
grep search-term --exclude-dir=.. -r .*
```

##### To search and ignore binary files

```sh
grep search-term -I *
```

##### To get all lines except lines with the specified word

```sh
grep -v search-term text.txt
```

##### find BOM characters in files

```sh
grep -rl $'\xEF\xBB\xBF' .
```

##### To use regular expression

```sh
grep -E '^token'
```

##### To show lines after the match

```sh
grep -A 2 search-term
```

This show 2 lines before the match (that is, a total of 3 lines).

##### To show lines before the match

```sh
grep -B 2 search-term
```

This show 2 lines before the match (that is, a total of 3 lines).

##### To show lines before and after the match

```sh
grep -C 2 search-term
```

This show 2 lines before and after the match (that is, a total of 5 lines).

