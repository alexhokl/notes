- [Convertions](#convertions)
  * [From 1024-based numbers](#from-1024-based-numbers)
- [Formatting](#formatting)
  * [Padding](#padding)
____

# Convertions

## From 1024-based numbers

```sh
numfmt --from=iec 1k
numfmt --from=iec 1M
numfmt --from=iec 1G
numfmt --from=iec 1T
```

# Formatting

## Padding

```sh
seq 1 10 | numfmt --padding=5
```

