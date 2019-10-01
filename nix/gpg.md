##### To list all public keys

```sh
gpg -k
```

##### To list all private keys

```sh
gpg -K
```

##### To list all key IDs

```sh
gpg -K --keyid-format LONG | grep sec | awk '{ print $2 }' | awk -F '/' '{ print $2 }'
```

##### To export private key

```sh
gpg --export-secret-keys -a your-key-id
```

`-a` to ascii-armored the key

##### To export public key

```sh
gpg --export -a your-key-id
```

##### To import GPG key(s) from a file

```sh
gpg --import filename.asc
```

##### To import GPG key(s) from another machine via SSH

```sh
ssh user_name@server_name gpg --export-secret-key your-key-id | gpg --import
```

##### To import a public key from key server

```sh
gpg --keyserver hkps://pgp.mis.edu --recv-keys your-key-id
```

##### To generate a key

```sh
gpg --gen-key
```

and select "RSA and RSA", select 4096 as keysize, select "key does not expire",
    and enter email address for this key

or, to generate a full featured key

```sh
gpg --full-generate-key
```

##### To edit a key

```sh
gpg --edit-key your-key-id
```

##### To sign a file

```sh
gpg -s something.txt
```

and a signature will be generated as file `something.txt.gpg`

##### To verify a signature

```sh
gpg --verify something.txt.gpg
```

##### To encrypt with symmetric cipher and passphrase

```sh
gpg -c something.txt
```

##### To encrypt with one of the store public keys

```sh
gpg -e something.txt
```

Enter the email address of the recipients upon being asked for `uid`

or, with specified recipient

```sh
gpg -r user@test.com -e something.txt
```

##### To decrypt

```sh
gpg -o something.txt --decrypt something.txt.gpg
```
