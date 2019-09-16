###### find unique file prefixes

if the files are named like Day1.00202.jpg, Day2.02311.jpg, ...

```sh
ls | cut -d. -f1 | uniq
```

###### create directories with unique file prefixes

if the files are named like Day1.00202.jpg, Day2.02311.jpg, ...

```sh
mkdir $(ls | cut -d. -f1 | uniq)
```

###### to get only duplicate lines

```sh
cat some.txt | uniq -d
```

###### to get only unique lines

```sh
cat some.txt | uniq -u
```

###### to ignore case

```sh
cat some.txt | uniq -i
```

###### to get count as well

```sh
cat some.txt | uniq -c
```

