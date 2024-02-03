- [Installations](#installations)
- [Commands](#commands)
____

# Installations

- [age](https://github.com/FiloSottile/age)
- [age-plugin-yubikey](https://github.com/str4d/age-plugin-yubikey)

# Commands

## Key generation

### Without Yubikey

##### to generate key pair without Yubikey

```sh
age-keygen -o someone.txt
```

where `someone.txt` contains private key and public key is prompted on screen.

### With Yubikey

`age-plugin-yubikey` has the following concepts.

- serial - serial number of your Yubikey
- slot - ID of slot on your Yubikey and there are usually 20 on a Yubikey
- name - name of a identity used by `age`
- policies - such as PIN and touch policy

All these concepts are stored on Yubikey and can be exported in the future.

##### to interactively generate key on Yubikey

```sh
age-plugin-yubikey
```

##### to generate key on Yubikey using the default Yubikey (or currently inserted one)

Note that this option is not so interactive as there are some defaults applied
such as identity name, slot number and policies.

```sh
age-plugin-yubikey --generate
```

##### to export identity to a file for later decryption processes

```sh
age-plugin-yubikey --identity --slot 1 > someone.txt
```

`someone.txt` would contain something like the following.

```
#       Serial: 12345999, Slot: 1
#         Name: someone@test.com
#      Created: Sat, 01 Jan 2023 08:00:00 +0000
#   PIN policy: Once   (A PIN is required once per session, if set)
# Touch policy: Always (A physical touch is required for every decryption)
#    Recipient: age1yubikey1qdpzh5suu99aak6w7ejwh8tlafvkvuleyhwnvecnhppsz0duukqhgpgm5k4
AGE-PLUGIN-YUBIKEY-2ABCDEF
```

`Recipient` is the public key to be shared by encryption purpose.

## Operations

##### to encrypt

```sh
cat something.txt | age -r $AGE_PUBLIC_KEY > something.txt.age
```

where `AGE_PUBLIC_KEY` is the string of the public key

or, using a file with public key,

```sh
cat something.txt | age -R someone_public.txt > something.txt.age
```

##### to decrypt

```sh
age --decrypt -i someone.txt something.txt.age > something.txt
```

If Yubikey is used, the program will ask for PIN in terminal. After entering the
PIN, if the following is shown, it is waiting for a touch on the Yubikey.

```
age: waiting on yubikey plugin...
```

##### to list recipients

```sh
age-plugin-yubikey --list
```

where `someone.txt` contains private key generated via `age-keygen`.
