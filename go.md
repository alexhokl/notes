# Go

### Links

- [Dave Cheney](https://dave.cheney.net/)
- [Testing GO HTTP API](http://dennissuratna.com/testing-in-go/)
- [A Recap of Request Handling in Go](http://www.alexedwards.net/blog/a-recap-of-request-handling)
- [Important interfaces that every Go developer should know](https://www.rzaluska.com/blog/important-go-interfaces/)
- [Grumpy: Go running Python!](https://opensource.googleblog.com/2017/01/grumpy-go-running-python.html)

### Libraries

- [DATA-DOG/go-sqlmock](https://github.com/DATA-DOG/go-sqlmock)
- [uber-go/zap](https://github.com/uber-go/zap)
- [go-chi/chi](https://github.com/go-chi/chi)

### Tricks

- Use `.Equals` instead of `==` to compare Time objects.

### Commands

List of all `GOOS` and `GOARCH` can be found in [`syslist.go`](https://github.com/golang/go/blob/master/src/go/build/syslist.go)


To build Windows executable on Mac

``` sh
GOOS=windows GOARCH=amd64 go build -o list.exe list.go
```

To check if any errors that is not handled
```sh
errcheck
```

To format the code
```sh
go fmt -d main.go
```

To test a project
```sh
go test ./...
`

To list all the tests in a project

```sh
go test -test.list .
```
