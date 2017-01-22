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
