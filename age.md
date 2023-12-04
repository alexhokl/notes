- [Installations](#installations)
- [Commands](#commands)
____

# Installations

- [age](https://github.com/FiloSottile/age)
- [age-plugin-yubikey](https://github.com/str4d/age-plugin-yubikey)

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

##### to generate key on Yubikey interactively

```sh
age-plugin-yubikey
```

##### to generate key on Yubikey using the default Yubikey (or currently inserted one)

```sh
age-plugin-yubikey --generate
```

##### to export identity to a file for later decryption processes

```sh
age-plugin-yubikey --identity --slot 1 > someone.txt
```

