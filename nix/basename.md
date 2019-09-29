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
