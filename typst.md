- [Links](#links)
- [Commands](#commands)
- [Syntax](#syntax)
    + [Title](#title)
    + [Points](#points)
    + [Figure](#figure)
    + [Bibliography](#bibliography)
    + [Equation](#equation)
____

# Links

- [Writing in Typst](https://typst.app/docs/tutorial/writing-in-typst/)

# Commands

```sh
typst compile temp.typ temp.pdf
```

# Syntax

### Title

```
= Introduction
```

### Points

In numbers

```
+ point 1
+ point 2
+ point 3
```

In bullets

```
- point 1
- point 2
- point 3
```

### Figure

```
#figure(
  image("images/thanos-deployment.jpg", width: 80%),
  caption: [
    Thanos deployment
  ]
)
```

### Bibliography

Assuming a Hayagriva file of `references.md` has been prepared.

```yaml
on_photograpghy:
  type: Book
  title: On Photography
  author: Susan Sontag
  volume: 24
  date: 1977-06-23
```

```
This contains a reference @on_photograpghy.

#bibliography("references.yml")
```

Reference: [The Hayagriva YAML File
Format](https://github.com/typst/hayagriva/blob/main/docs/file-format.md)

### Equation

```
$ Q = rho A v + "time offset" $
```

Note that the equation above will be rendered in the centre of PDF. In case the
equation inlined in text, no indentation will be applied.
