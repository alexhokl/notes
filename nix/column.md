- [column](#column)
___

# column

Note that this is referring to `column` on Linux and MacOS may not have all the
options.

```sh

##### To list items in columns

```sh
cat list | column
```

By default, it fills a column and then extend from left to right.

To fill a row first,

```sh
cat list | column -x
```

##### To list items in table mode

Assuming a row is delimited by `:`,

```sh
cat list | column -t -s ":"
```

To add headers,

```sh
cat list | column -t -s ":" -N "Header1,Header2,Header3"
```

To hide a column,

```sh
cat list | column -t -s ":" -H 2
```

or

```sh
cat list | column -t -s ":" -N "Header1,Header2,Header3" -H "Header2"
```

To reorder columns,

```sh
cat list | column -t -s ":" -O 3,1,2
```

or

```sh
cat list | column -t -s ":" -N "Header1,Header2,Header3" -O "Header3,Header1,Header2"
```

##### To list items in JSON

```sh
cat list | column -t -s ":" -N "Header1,Header2,Header3" -J -n someJsonPropertyName
```
