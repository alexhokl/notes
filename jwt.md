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
  - protected` - with the value BASE64URL(UTF8(JWS Protected Header))
  - header` - with the value JWS Unprotected Header
  - payload` - with the value BASE64URL(JWS Payload)
  - signature` - with the value BASE64URL(JWS Signature)

