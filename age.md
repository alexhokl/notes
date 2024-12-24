- [Links](#links)
- [Installations](#installations)
- [Commands](#commands)
  * [Key generation](#key-generation)
    + [Without Yubikey](#without-yubikey)
    + [With Yubikey](#with-yubikey)
  * [Operations](#operations)
- [Concepts](#concepts)
  * [Age file](#age-file)
    + [Example of textual header](#example-of-textual-header)
    + [questions](#questions)
  * [Conventions](#conventions)
____

# Links

- [awesome-age](https://github.com/FiloSottile/awesome-age)

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

or, to format the encrypted file as PEM,

```sh
cat something.txt | age --armor -r $AGE_PUBLIC_KEY > something.txt.age.pem
```

##### to decrypt

```sh
age --decrypt -i someone.txt something.txt.age > something.txt
```

where `someone.txt` contains private key generated via `age-keygen` (or
`age-plugin-yubikey -i` as above)

If Yubikey is used, the program will ask for PIN in terminal. After entering the
PIN, if the following is shown, it is waiting for a touch on the Yubikey.

```
age: waiting on yubikey plugin...
```

##### to list recipients

```sh
age-plugin-yubikey --list
```

# Concepts

- It is an encryption format
- it supports seekable streaming encryption
- key generation is not deterministic and it implies passphrase alone is not
  enough to decrypt data but the corresponding key file is needed as well

## Age file

- textual header
  * version line
  * list of recipient stanza
    + a base64-encoded body wrapped at 64 columns (43 characters?)
    + wraps the same file key independently
      + file key
        + a 128-bit (16-byte) symmetric key
        + it cannot be re-used arcoss multiple files
        + an output of a cryptographically secure pseudo-random number generator
          (`CSPRNG`)
        + used by mutiple recipients
    + recipient implementations MAY choose to include an identifier of the
      specific recipient (for example, a short hash of the public key) as an
      argument. Note that this sacrifices any chance of ciphertext anonymity and
      unlinkability.
  * MAC
    + computed with `HMAC-SHA-256` (see [RFC
      2104](https://tools.ietf.org/html/rfc2104)) over the whole header up to
      and including the `---` mark
- binary payload (encrypted with file key in the textual header)
  * 16-byte nonce (generated on per-file basis)
  * splitted into `64 KiB` chunks
    + `payload key = HKDF-SHA-256(ikm = file key, salt = nonce, info = "payload")`
    + each encrypted with `ChaCha20-Poly1305` (see [RFC
      7539](https://tools.ietf.org/html/rfc7539)), using the payload key and
      a 12-byte nonce (where the first 11 bytes are big endian chunck counter
      starting at zero; the last byte is `0x01` for the final chunk and `0x00`
      for all preceding ones)
    + this is a stream variant from Online Authenticated-Encryption and its
      Nonce-Reuse Misuse-Resistance
    + it can be streamed by decrypting or encrypting one chunk at a time

### Example of textual header

```
age-encryption.org/v1
-> X25519 XEl0dJ6y3C7KZkgmgWUicg63EyXJiwBJW8PdYJ/cYBE
qRS0AMjdjPvZ/WT08U2KL4G+PIooA3hy38SvLpvaC1E
--- HK2NmOBN9Dpq0Gw6xMCuhFcQlQLvZ/wQUi/2scLG75s
```

### X25519 recipient stanza

The first part is the fixed string `X25519` and the second part is
base64-encoded ephemeral share.

```
ephemeral secret = read(CSPRNG, 32)
ephemeral share = X25519(ephemeral secret, basepoint)
```

where a new ephemeral secret is generated for each stanza.

```
salt = ephemeral share || recipient
info = "age-encrryption.org/v1/X25519"
shared secret = X25519(ephemeral secret, recipient)
wrap key = HKDF-SHA-256(ikm = shared secret, salt = salt, info = info)
body = ChaCha20-Poly1305(key = wrap key, plaintext = file key)
```

where ChaCha20-Poly1305 nonce is fixed as 12 `0x00` bytes.

See [Identity file](#identity-file) for the definition of `recipient`.

```
shared secret = X25519(identity, ephemeral share)
```

### Scrypt recipient stanza

The first part is the fixed string `scrypt` and the second part is
base64-encoded salt computed by the recipient implementation  as 16 bytes from
a CSPRNG, and the third part is the base-two logarithm of the scrypt work factor
in decimal.

A new salt is generated for each stanza and each file.

```
wrap key = scrypt(N = work factor, r = 8, p = 1, dkLen = 32, S = "age-encryption.org/v1/scrypt" || salt, P = passphrase)
body = ChaCha20-Poly1305(key = wrap key, plaintext = file key)
```

Scrypt is defined in [RFC 7914](https://tools.ietf.org/html/rfc7914).

## Identity file

### Recipient types

- an asymmetric encryption type based on X25519
- a passphrase encryption type based on scrypt

#### X25519 recipient type

```
identity = read(CSPRNG, 32)
```

where `identity` is encoded as Bech32 with HRP `AGE-SECRET-KEY-`.

An example of `identity` is as follows.

```
AGE-SECRET-KEY-1GFPYYSJZGFPYYSJZGFPYYSJZGFPYYSJZGFPYYSJZGFPYYSJZGFPQ4EGAEX
```

Bech32 is a segregated witness (SegWit) address format used in some
cryptocurrencies. See [this link](https://en.bitcoin.it/wiki/Bech32) for more
detail. HRP refers to "human-readable part".

Note that the `identity` is somehow worked like a private key.

```
receipient = X25519(identity, basepoint)
```

where `basepoint` is the Curve25519 base point and `X25519` is the function that
represents an elliptic curve Diffie-Hellman (ECDH) key exchange which uses
Curve25519 and it accepts any 32-byte string as a valid public key; `receipient`
is also encoded as Bech32 with HRP `age`.

An example of `recipient` is as follows.

```
age1zvkyg2lqzraa2lnjvqej32nkuu0ues2s82hzrye869xeexvn73equnujwj
```

Note that the `recipient` is somehow worked like a public key.

## Conventions

- standard Base 64 encoding implies no `=` padding characters
- nonce is an arbitrary number that can be used only once in a cryptographic
  communication
  * it is often a random or pseudo-random number issued in an authentication
    protocol to ensure that each communication session is unique, and therefore
    that old communications cannot be reused in replay attacks
- HKDF-SHA-256 (defined in [RFC 5869](https://tools.ietf.org/html/rfc5869)) is
used for key derivation
  * it uses HMAC
  * it follows "extract-then-expand" paradigm
    + extract stage takes the input keying material and extracts from it
      a fixed-length pseudorandom key (PRK) using HMAC-SHA-256
    + expand stage then expands this PRK into the desired number of output keys
      of the required length, again using HMAC-SHA-256
- ChaCha20-Poly1305 (defined in [RFC 7539](https://tools.ietf.org/html/rfc7539))
  is the AEAD encryption function
  * authenticated encryption with associated data (AEAD) algorithm that combines
    the ChaCha20 stream cipher with the Poly1305 message authentication code
    (MAC)
  * it is a symmetric encryption algorithm
