
____

To remove any strings before /

```sh
basename /home/user/something.txt
```

returns `something.txt`


To remove any strings before / and after .

```sh
basename /home/user/something.txt .txt
```

returns `something`


To return without newline (by default)

```sh
basename -z /home/user/something.txt
```

To do the same without `basename`

```sh
$ export VAR=/home/me/mydir/file.c
$ export DIR=${VAR%/*}
$ echo "${DIR}"
/home/me/mydir

$ echo "${VAR##*/}"
file.c
```
