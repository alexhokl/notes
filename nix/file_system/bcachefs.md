- [Bcachefs](#bcachefs)
  * [Links](#links)
  * [Notes](#notes)
  * [Features](#features)
___

# Bcachefs

## Links

- [Bcachefs](https://bcachefs.org/)
- [Wikipedia](https://en.wikipedia.org/wiki/Bcachefs)

## Notes

- included in Linux 6.7 kernel in January 2024
- as of August 2024, "nobody sane uses bcachefs and expects it to be stable"

## Features

- copy-on-write
- caching
- full file-system encryption
  * using the ChaCha20-Poly1305 cipher
- native compression
  * via LZ4, gzip, Zstandard, snapshots, CRC32C and 64-bit checksums
- it can span block devices including in RAID configurations
- snapshots
  * not implemented by cloning a copy-on-write tree, but by adding a version
    number to filesystem objects
