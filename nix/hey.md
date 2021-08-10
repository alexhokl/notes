- [To request against a plain URL](#to-request-against-a-plain-url)
____
### To request against a plain URL 

```sh
hey -n 10 -c 1 -m POST https://www.google.com
```

or, to make output with CSV format in console

```sh
hey -n 10 -c 1 -m POST -o csv https://www.google.com
```
