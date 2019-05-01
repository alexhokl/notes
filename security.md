# OAuth 2.0

### Links

- [RFC-6749 - OAuth 2.0 spec](https://tools.ietf.org/html/rfc6749)
- [How To Control User Identity Within Microservices](http://nordicapis.com/how-to-control-user-identity-within-microservices/)
- [A Guide To OAuth 2.0 Grants](https://alexbilbie.com/guide-to-oauth-2-grants/)
- [Libraries](https://oauth.net/code/)
- [GOTO 2018 • Introduction to OAuth 2.0 and OpenID Connect • Philippe De
    Ryck](https://www.youtube.com/watch?v=GyCL8AJUhww)
- [Why the Resource Owner Password Credentials Grant Type is not Authentication nor Suitable for Modern Applications](https://www.scottbrady91.com/OAuth/Why-the-Resource-Owner-Password-Credentials-Grant-Type-is-not-Authentication-nor-Suitable-for-Modern-Applications)

# OpenID

- the ID tokens issued are supposed to be used by client and should not be
  consumed by APIs

# JWT

##### Abstract

- The claims in a JWT
   are encoded as a JSON object that is used as the payload of a JSON
   Web Signature (JWS) structure or as the plaintext of a JSON Web
   Encryption (JWE) structure, enabling the claims to be digitally
   signed or integrity protected with a Message Authentication Code
   (MAC) and/or encrypted.

##### Introduction

- JWTs are always
   represented using the JWS Compact Serialization or the JWE Compact
   Serialization.

##### Terminology

- JSON Web Token (JWT) - A string representing a set of claims as a JSON object that is
      encoded in a JWS or JWE, enabling the claims to be digitally
      signed or MACed and/or encrypted.
- NumericDate - A JSON numeric value representing the number of seconds from
      1970-01-01T00:00:00Z UTC until the specified UTC date/time, ignoring leap seconds

##### JSON Web Token (JWT) Overview

- The contents of the JOSE Header describe the cryptographic operations
   applied to the JWT Claims Set.
- If the JOSE Header is for a JWS, the
   JWT is represented as a JWS and the claims are digitally signed or
   MACed, with the JWT Claims Set being the JWS Payload.
- If the JOSE
   Header is for a JWE, the JWT is represented as a JWE and the claims
   are encrypted, with the JWT Claims Set being the plaintext encrypted
   by the JWE.
- A JWT is represented as a sequence of URL-safe parts separated by
   period ('.') characters.  Each part contains a base64url-encoded
   value.  The number of parts in the JWT is dependent upon the
   representation of the resulting JWS using the JWS Compact
   Serialization or JWE using the JWE Compact Serialization.

###### Example on JWS MACed using the HMAC SHA-256

Combination of the following 3 components

- base64 encoded UTF-8 JOSE headers
- base64 encoded JWT claim set
- base64 encoded HMAC SHA-256 signature (or value) of (ASCII(BASE64URL(UTF8(JWS Protected Header)) || '.' || BASE64URL(JWS Payload)))

##### JWT Claims

- The Claim Names within a JWT Claims Set
   MUST be unique
- all claims that are not understood
   by implementations MUST be ignored.
- There are three classes of JWT Claim Names: Registered Claim Names,
   Public Claim Names, and Private Claim Names.
- See [registered claim names](https://tools.ietf.org/html/rfc7519#section-4.1)
  for a set of commonly used names

##### Unsecured JWTs

- just leave the signature part empty

## JWS

- headers are union of the following two
  - JWS protected header
  - JWS unprotected header
- two types of serialisation
  - JWS Compact Serialization (probably the most common one)
  - JWS JSON Serialization
- header `crit` is an array and it specifies that the implementation must be
  able to understood and process this headers listed in the array

##### JWS Compact Serialization

- no JWS unprotected header

##### JWS JSON Serialization

- combination of the following components
  - `protected` - with the value BASE64URL(UTF8(JWS Protected Header))
  - `header` - with the value JWS Unprotected Header
  - `payload` - with the value BASE64URL(JWS Payload)
  - `signature` - with the value BASE64URL(JWS Signature)

# SSL

### .csr (Certificate Signing Request)

Some applications can generate these for submission to certificate-authorities. The actual format is PKCS10 which is defined in [RFC 2986](https://tools.ietf.org/html/rfc2986). It includes some/all of the key details of the requested certificate such as subject, organization, state, whatnot, as well as the public key of the certificate to get signed. These get signed by the CA and a certificate is returned. The returned certificate is the public certificate (which includes the public key but not the private key), which itself can be in a couple of formats.

### .pem (Privacy Enhanced Mail)

Defined in [RFC 1421](https://tools.ietf.org/html/rfc1421), [RFC 1422](https://tools.ietf.org/html/rfc1422), [RFC 1423](https://tools.ietf.org/html/rfc1423), [RFC 1424](https://tools.ietf.org/html/rfc1424), this is a container format that may include just the public certificate (such as with Apache installs, and CA certificate files `/etc/ssl/certs`), or may include an entire certificate chain including public key, private key, and root certificates. Confusingly, it may also encode a CSR (e.g. as used here) as the PKCS10 format can be translated into PEM. It is a base64 translation of the x509 ASN.1 keys.

### .key

This is a PEM formatted file containing just the private-key of a specific certificate and is merely a conventional name and not a standardized one. In Apache installs, this frequently resides in `/etc/ssl/private`. The rights on these files are very important, and some programs will refuse to load these certificates if they are set wrong.

### .pkcs12 .pfx .p12

Originally defined by RSA in the Public-Key Cryptography Standards, the "12" variant was enhanced by Microsoft. This is a passworded container format that contains both public and private certificate pairs. Unlike .pem files, this container is fully encrypted. Openssl can turn this into a .pem file with both public and private keys: `openssl pkcs12 -in file-to-convert.p12 -out converted-file.pem -nodes`

### .der

A way to encode ASN.1 syntax in binary, a .pem file is just a Base64 encoded .der file. OpenSSL can convert these to .pem (`openssl x509 -inform der -in to-convert.der -out converted.pem`). Windows sees these as Certificate files. By default, Windows will export certificates as .DER formatted files with a different extension.

### .cert .cer .crt

A .pem (or rarely .der) formatted file with a different extension, one that is recognized by Windows Explorer as a certificate, which .pem is not.

### .p7b

Defined in [RFC 2315](https://tools.ietf.org/html/rfc2315), this is a format used by windows for certificate interchange. Java understands these natively. Unlike .pem style certificates, this format has a defined way to include certification-path certificates.

### .crl (Certificate revocation list)

Certificate Authorities produce these as a way to de-authorize certificates before expiration. You can sometimes download them from CA websites.
