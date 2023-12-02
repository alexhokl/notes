- [Commands](#commands)
____

# Commands

##### to generate key pair

```sh
age-keygen -o someone.txt
```

where `someone.txt` contains private key and public key is prompted on screen.

##### to encrypt

```sh
cat something.txt | age -r $AGE_PUBLIC_KEY > something.txt.age
```

##### to decrypt

```sh
age --decrypt -i someone.txt something.txt.age > something.txt
```

where `someone.txt` contains private key generated via `age-keygen`.
