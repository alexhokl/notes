- [Coding](#coding)
  * [Agents](#agents)
    + [General tricks](#general-tricks)
    + [Go](#go)
____

# Coding

## Agents

### General tricks

#### Fetching web pages

HTTP header `Accept: text/markdown` should be used to fetch web pages in
markdown format, if the server (such as cloudflare) supports it.

### Go

- To see source files from a dependency, or to answer questions about a
  dependency, run `go mod download -json MODULE` and use the returned `Dir` path
  to read the files
- Use `go doc foo.Bar` or `go doc -all foo` to read documentation for packges,
  types, functions, etc.
- Use `go run .` or `go run ./cmd/foo` instead of `go build` to run programs, to
  avoid leaving behind build artifacts

