### Modular Multiplicative Inverse

To compute modular multiplicative inverse `d` of `e (mod n)` using Extended
Euclidean Algorithm

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

- Pick two primes
  - for instance, `7` and `13`
- Calculate `n` where it is the product of the two primes
  - `n = 7 x 13 = 91` 
- Compute Euler's totient function of `n`
  - `φ(91) = (7-1)(13-1) = 72`
- Pick a random number `e` where `1 < e < φ(n)`
  - and let's pick `e = 23`
- Compute modular multiplicative inverse `d` of `e (mod φ(n))`
  - that is, `23d = 1 (mod 72)`
  - using Chinese Remainder Theorem,` d = 47`
- From the calculations above,
  - public key = `(n = 91, e = 23)`
  - private key = `(n = 91, d = 47)`
- Let message `m = 60`
- Compute cipher `c` using public key (n,e) `c = m^e mod n = 60^23 mod 91 = 44`
- Decrypt cipher using private key (n,d) `m = c^d mod n = 44^47 mod 91 = 60`

