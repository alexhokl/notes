### Links

- [End-to-end encryption: Behind the scenes](https://www.youtube.com/watch?v=oRZoeDRACrY)

### Modular Multiplicative Inverse

To compute modular multiplicative inverse `d` of `e (mod n)` using [Extended
Euclidean Algorithm](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm)

Let `e = 23` and `n = 72`

```
23d = 1 (mod 72)
d = 23^-1 (mod 72)
72 = 23 x 3 + 3
23 = 3 x 7 + 2
3 = 2 x 1 + 1
1 = 3 + 2 (-1)
1 = 3 + (23 + 3(-7))(-1) = 23(-1) + 3(8)
1 = 23(-1) + (72 + 23(-3))(8) = 72(8) + 23(-25)
```

Apply `mod 72` on both sides, and since `-25 (mod 72) = 47 (mod 72)`,
`d = 47`

### Public Key Cryptography

#### RSA (Rivest–Shamir–Adleman)

- Pick two primes
  - for instance, `7` and `13`
- Calculate `n` where it is the product of the two primes
  - `n = 7 x 13 = 91` 
- Compute Euler's totient function of `n`
  - `φ(91) = (7-1)(13-1) = 72`
- Pick an integer `e` where `1 < e < φ(n)` and `e` is a [coprime](https://en.wikipedia.org/wiki/Coprime_integers)
    of `n`.
  - and let's pick `e = 23`
- Since `de ≡ 1 (mod φ(n))`, that is `m^(de) = m (mod n)`
  - compute modular multiplicative inverse `d` of `e (mod φ(n))`
  - that is, `23d = 1 (mod 72)`
  - using Extended Euclidean algorithm,` d = 47`
- From the calculations above,
  - public key = `(n = 91, e = 23)`
  - private key = `(n = 91, d = 47)`
- Let message `m = 60`
- Compute cipher `c` using public key (n,e) `c = m^e (mod n) = 60^23 (mod 91) = 44`
- Decrypt cipher using private key (n,d) `m = c^d (mod n) = 44^47 (mod 91) = 60`

#### PGP (Pretty Good Privacy)

##### Process

- Assuming Alice wants to send message `msg` to Bob
  - let `Apub`, `Apriv`, `Bpub` and `Bpriv` be public and private key of Alice
      and Bob respectively
- Alice generates a random key `k`
- Alice generates a signature `sig` using her private key and hash of `msg`
- Alice generates a symmetric cipher `c` using `k` and the combination of `sig` and `msg`
- Alice sends `c` and `k^(Bpub)` to Bob
- Bob computes `k` by ``k^(Bpub)^(Bpriv) = k`` 
- Bob decrypts the symmetric cipher `c` using the computed `k` and get `sig`
    and `msg`
- Bob can check `sig` using `Apub` and hash of` msg`

##### Concerns

- All stored ciphers can be easily decrypted once the private key is compromised

#### Diffie-Hellman

##### Process

- Assuming number `g` and `p` are known to the public and Alice wants to message `msg`
    to Bob
- Alice generates a random `x1` and sends `g^(x1)` to Bob
- Bob generates a random `y1` and send `g^(y1)` to Alice
- Alice and Bob now can compute shared key `K1` where `K1 = g^(y1)^(x1) (mod p)`
- Alice can then encrypt `msg` using symmetric key `K1` and Bob can decrypt the
    message with the same key
- Forward and backward secrecy can be archived by generating `x` and `y` for
    each message exchanged
- Off-line scenario can handled by generated `g^y` numbers beforehand and upload
    them to a server

##### Drawbacks

- It does not handle the problem of man-in-the-middle attacks

#### HMAC (Hash-based message authentication code)

- HMAC is a hash of combination of shared key and hash of combination of shared
    key and message
- To extend Diffie-Hellman with HMAC
  - Assuming Alice wants to send a message to Bob and generates the required
      `x` and `y`
  - Alice sends `g^x` to Bob
  - Bob computes shared key `k` by calculating the hash of `g^(xy)`
  - Bob, instead of sending just `g^(y)` to Alice, sends `Bpub` and
      signature of HMAC of combination of `g^x`, `g^y` and `Bpub` using `k`
  - Alice computes shared key `k` by calculating the hash of `g^(xy)`
  - Alice can then verify that the shared key is indeed coming from Bob
  - Alice then sends `Apub` and signature of HMAC of combination of `g^x`, `g^y` and
      `Apub` using `k`to Bob
  - Bob can then verify that the shared key is indeed coming from Alice

##### Advantages

| | Sender proves | Who can check? |
| --- | --- | --- |
| digital signatures | knows private key | anyone |
| HMAC | knows shared key | someone how knows the shared key |

