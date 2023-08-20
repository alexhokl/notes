- [Commands](#commands)
- [Syntax](#syntax)
  * [New slide](#new-slide)
  * [Metadata](#metadata)
____

# Commands

```sh
slides test.md
```

Note that `test.md` has to be executable (which means `chmod +x test.md` is
required).

# Syntax

## New slide

```md
---
```

## Metadata

```md
---
theme: ./path/to/theme.json
author: Gopher
date: MMMM dd, YYYY
paging: Slide %d / %d
---
```
