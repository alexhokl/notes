###### To list all GPG keys

```sh
gpg -K
```

```sh
gpg --list-secret-keys --keyid-format LONG
```

###### To export all GPG keys to a file

```sh
gpg --export-secret-keys -a > filename.asc
```

###### To export public key

```sh
gpg --armor --export the-key-id
```

###### To import GPG key(s) from a file

```sh
gpg --import filename.asc
```

###### To import GPG key(s) from another machine via SSH

```sh
ssh user_name@server_name gpg --export-secret-key KEY_ID | gpg --import
```

###### To generate a key

```sh
gpg --gen-key
```

and select "RSA and RSA", select 4096 as keysize, select "key does not expire",
    and enter email address for this key

