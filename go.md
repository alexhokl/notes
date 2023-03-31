- [Links](#links)
- [Libraries](#libraries)
  * [Database](#database)
  * [Logging](#logging)
  * [Web](#web)
  * [CLI](#cli)
  * [Unit testing](#unit-testing)
  * [GUI](#gui)
  * [Kafka](#kafka)
  * [Finance](#finance)
  * [Security](#security)
  * [Others](#others)
- [Tricks](#tricks)
- [Commands](#commands)
  * [Testing](#testing)
  * [Modules](#modules)
  * [Help](#help)
- [Swagger](#swagger)
- [Language](#language)
  * [Error handling](#error-handling)
  * [main function](#main-function)
  * [Functional options](#functional-options)
  * [Interface](#interface)
  * [sync.WaitGroup](#syncwaitgroup)
  * [Channels](#channels)
  * [errgroup](#errgroup)
  * [SIGTERM handling](#sigterm-handling)
  * [panic](#panic)
  * [signal.NotifyContext](#signalnotifycontext)
  * [os.Exit](#osexit)
  * [cmd](#cmd)
  * [Sprintf](#sprintf)
  * [Printf](#printf)
  * [Embed](#embed)
  * [Module](#module)
  * [Array, slice, reference and range](#array-slice-reference-and-range)
- [Charm](#charm)
  * [Bubbletea](#bubbletea)
- [Vs Rust](#vs-rust)
____

## Links

- [Dave Cheney](https://dave.cheney.net/)
- [Practical Go - Dave Cheney](https://dave.cheney.net/practical-go)
- [Testing GO HTTP API](http://dennissuratna.com/testing-in-go/)
- [A Recap of Request Handling in Go](http://www.alexedwards.net/blog/a-recap-of-request-handling)
- [Important interfaces that every Go developer should know](https://www.rzaluska.com/blog/important-go-interfaces/)
- [Grumpy: Go running Python!](https://opensource.googleblog.com/2017/01/grumpy-go-running-python.html)
- [Gopherize.me](https://gopherize.me/)
- [Conference talks from Liz Rice](https://www.lizrice.com/talks)
- [Go Time Podcast](https://changelog.com/gotime)
- [Code review comments](https://github.com/golang/go/wiki/CodeReviewComments)
- [Top Go Web Frameworks](https://github.com/mingrammer/go-web-framework-stars)
- [Programming the Windows
  firewall](https://tailscale.com/blog/windows-firewall/)

## Libraries

### Database

- [DATA-DOG/go-sqlmock](https://github.com/DATA-DOG/go-sqlmock)
- [go-jet/jet](https://github.com/go-jet/jet) generates `struct`s from a database
  connection but it is not an ORM tool. It also allows serialising data into
  custom `struct` created from the generated `struct`s.

### Logging

- [uber-go/zap](https://github.com/uber-go/zap) Blazing fast, structured,
  leveled logging in Go
  [example](https://github.com/uber-go/zap/blob/master/example_test.go),
  [FAQ](https://github.com/uber-go/zap/blob/master/FAQ.md)

### Web

- [go-chi/chi](https://github.com/go-chi/chi) lightweight, idiomatic and composable router for building Go HTTP services
- [gorilla/websocket](https://github.com/gorilla/websocket)
- [microcosm-cc/bluemonday](https://github.com/microcosm-cc/bluemonday/) a HTML
  sanitizer
- [twitchtv/twirp](https://github.com/twitchtv/twirp) A simple RPC framework
  with protobuf service definitions

### CLI

- [spf13/viper](https://github.com/spf13/viper) for application configurations
- [urfave/cli](https://github.com/urfave/cli) for building command line applications
- [cohesivestack/valgo](https://github.com/cohesivestack/valgo) validates user
  input

### Unit testing

- [leanovate/gopter](https://github.com/leanovate/gopter) property testing

### GUI

- [fyne-io/fyne](https://github.com/fyne-io/fyne) - purely in Go
- [wailsapp/wails](https://github.com/wailsapp/wails) - combining Go and HTML

### Kafka

- [Shopify/sarama](https://github.com/Shopify/sarama) a Go library for Apache
  Kafka 0.8, and up -
  [example](https://github.com/Shopify/sarama/blob/master/examples/http_server/http_server.go)

### Finance

- [sdcoffey/techan](https://github.com/sdcoffey/techan/) a Technical (Financial)
  Analysis Library for Golang
- [piquette/finance-go](https://github.com/piquette/finance-go) a Financial
  markets data library implemented in go

### Security

- [mattevans/pwned-passwords](https://github.com/mattevans/pwned-passwords) Go
  client library for checking values against compromised HIBP Pwned Passwords
- [xeals/signal-back](https://github.com/xeals/signal-back) Decrypt Signal
  encrypted backups outside the app

### Others

- [src-d/enry](https://github.com/src-d/enry) A faster file programming language
  detector
- [schachmat/wego](https://github.com/schachmat/wego) weather app for the
  terminal
- [bryanl/manifest-summary](https://github.com/bryanl/manifest-summary) print
  summary of a kubernetes manifest

## Tricks

- Use `.Equals` instead of `==` to compare Time objects.
- Function parameters of interface type should not be a pointer as a normal
  interface parameter can accept both pointer and value. Function receiver (the
  parameter before function name) is the only exception. (see [Go interfaces
  and pointers](https://medium.com/@saiyerram/go-interfaces-pointers-4d1d98d5c9c6))
- For examples on pointers, see
  [alexhokl/go-pointers](https://github.com/alexhokl/go-pointers)
- Example on using OAuth with CLI
  [alexhokl/go-bb-pr](https://github.com/alexhokl/go-bb-pr)

## Commands

List of all `GOOS` and `GOARCH` can be found in [`syslist.go`](https://github.com/golang/go/blob/master/src/go/build/syslist.go)


###### To build Windows executable

``` sh
GOOS=windows GOARCH=amd64 go build -o list.exe list.go
```

###### To build without cgo

```sh
CGO_ENABLED=0 go build -v -o helloworld
```

###### To build with ldflags

Assuming there is string global variable `version` defined in package `cmd`

```sh
go build -ldflags "-X github.com/alexhokl/rds-backup/cmd.version=$(git rev-parse --short HEAD)"
```

###### To build and install locally

```sh
go install
```

###### To check if any errors that is not handled

```sh
errcheck
```

### Testing

###### To test a project

```sh
go test ./...
```

###### To test a project and view its test coverage

```sh
go test -cover ./...
```

###### To test a project and show its test coverage profile

```sh
go test -coverprofile=cover.out ./... && go tool cover -html=cover.out
```

###### To list all the tests in a project

```sh
go test -test.list .
```

###### To test all files with a short test results

```sh
go test --short all
```

### Modules

###### To list all module dependencies

```sh
go list -m all
```

###### To retrieve a specific version of library

```sh
go get library@version
```

###### To create a module

```sh
go mod init
```

##### To update dependencies

```sh
go mod tidy
```

##### To create a version

```sh
git tag v1.0.1 && git push --tags
```

### Help

##### To help page of a command

```sh
go help get
```

This shows the help page of command `go get`.

##### To upgrade Go version

```sh
go get golang.org/dl/go1.15.4
go1.15.4 download
```

## Swagger

##### To generate code from an API specification

```sh
git clone https://github.com/swagger-api/swagger-codegen
cd swagger-codegen
./run-in-docker.sh mvn package
./run-in-docker.sh generate -i https://developers.strava.com/swagger/swagger.json -l go -o generated/go
```

## Language

### Error handling

Wrapping error messages to give more information

```go
func Something() error {
  if err := someProcess(); err != nil {
    return fmt.Errorf("more error information: %w", err)
  }
  return nil
}
```

Note that `%w` is different from `%v` in that it gives a chance for higher level
code which invokes `Something` to check the type of `err` (which could be
a complicated `struct` implements `error` interface).

### main function

To handle error better, a slim `main` function can be written. This also allows
the program can be tested easily.

```go
const (
  // exitFail is the exit code if the program fails
  exitFail = 1
)

func main() {
  if err := run(os.Args, os.Stdout); err != nil {
    fmt.Fprintf(os.Stderr, "%s\n", err)
    os.Exit(exitFail)
  }
}

func run(args []string, stdout io.Writer) error {
  // ...
}
```

Reference: [Why you shouldn't use func main in
Go](https://pace.dev/blog/2020/02/12/why-you-shouldnt-use-func-main-in-golang-by-mat-ryer.html)

### Functional options

Reference: [Functional options for friendly
APIs](https://dave.cheney.net/2014/10/17/functional-options-for-friendly-apis)

A common pattern is used to create a new object is to pass in a configuration
object. For example,

```go
type Config struct {
  one string
  two string
}

func main() {
  config, _ := parseArguments(os.Args)
  mandatoryParameter := os.Args[1]
  instance, _ := NewInstance(mandatoryParameter, config)
  // ...
}
```

The above approach made it difficult to handle mandatory parameters and optional
parameters. Validations are much harder (although not impossible) to be done.
Optional configuration object has to be prepared by caller regardless.

Using functional options gives the following advantages.

- The number of options can grow easily over time (instead of growing
  configuration object
- It makes the default use case to be the simplest
- It provides meaningful configuration parameters
- It gives access to initialize complex values

```go
func NewInstance(mandatoryParameter string, options ...func(*Instance)) (*Instance, error) {
  i := &Instance{mandatoryParameter: mandatoryParameter}
  for _, o := range options {
    if err := o(i); err != nil {
      return nil, err
    }
  }
  return i, nil
}

func Debug(i *Instance) error {
  return i.setDebugMode()
}

func Limit(int limit) func(*Instance) error {
  return func(i *Instance) error {
    if limit <= 0 {
      return fmt.Errorf("Limit must be positive but it was %d", limit)
    }
    return i.setLimit(limit)
  }
}

func parseArguments(args []string) ([]func(*Instance) error) {
  var options []func(*Instance) error
  if args[2] == "debug" {
    options = append(options, Debug)
  }

  if args[3] == 'limit' {
    options = append(options, Limit(args[4]))
  }
  return options
}

func main() {
  options, _ := parseArguments(os.Args)
  mandatoryParameter := os.Args[1]
  instance, _ := NewInstance(mandatoryParameter, ...options)
  // ...
}
```

Note that `Limit` helps adapting the signature to what required as an option.
All functions except `main` can live in another package (and makes things as
clean as using a configuration object).

### Interface

It is always prefer to have less methods in an interface to make it precise and
easier to implement. Big interface can be created by composing using smaller
interfaces.

Usually interface is named with what its functions do. For instance, `io.Writer`
has function `Write`.

Although name of arguments and return values used in an interface are not
enforced in the types that implement the interface, it is encouraged to name
them to enhance documentation.

Parameters of functions of an interface should be a type of lowest common
denominator. For instance, if it is a choice between `string` and `byte[]`,
`[]byte` should be used as it can be implemented by more types.

Pointers can be passed to functions implementing a non-pointer method. For
instance,

```go
type Stringer interface {
  String() string
}

type Something struct {}

func (s Something) String() string {
  return "something"
}

func main() {
  s := &Something{}
  fmt.Println(s.String())
  // this compiles and should display "something"
}
```

### sync.WaitGroup

```go
func notify(services ...string) {
  var wg sync.WaitGroup

  for _, service := range services {
    wg.Add(1)
    go func(s string) {
      defer wg.Done()
      fmt.Printf("Starting to notifing %s...\n", s)
      time.Sleep(time.Duration(rand.Intn(3)) * time.Second)
      fmt.Printf("Finished notifying %s...\n", s)
    }(service)
  }

  wg.Wait()
  fmt.Println("All services notified!")
}
```

### Channels

```go
func notify(services ...string) {
  res := make(chan string)
  count := 0

  for _, service := range services {
    count++
    go func(s string) {
      fmt.Printf("Starting to notifying %s...\n", s)
      time.Sleep(time.Duration(rand.Intn(3)) * time.Second)
      res <- fmt.Sprintf("Finished %s", s)
    }(service)
  }

  for i := 0; i < count; i++ {
    fmt.Println(<-res)
  }

  fmt.Println("All services notified!")
}
```

### errgroup

`errgroup` can be found in package `golang.org/x/sync/errgroup`.

Note that `Wait()` returns on the first routine which returns an error.

```go
func notify(services ...string) {
  var g errgroup.Group

  for _, service := range services {
    // Copy the value from the service variable into a local variable to
    // avoid a common bug with closure inside a loop
    s := service
    g.Go(func() error {
      fmt.Printf("Starting to notifing %s...\n", s)
      time.Sleep(time.Duration(rand.Intn(3)) * time.Second)
      fmt.Printf("Finished notifying %s...\n", s)
      return nil // or a real error if we had one
    })
  }

  err := g.Wait()
  if err != nil {
    fmt.Printf("Error notifying services: %v\n", err)
    return
  }
  fmt.Println("All services notified successfully!")
}
```

### SIGTERM handling

```go
package main

import (
  "fmt"
  "os"
  "os/signal"
  "syscall"
)

func main() {

  sigs := make(chan os.Signal, 1)
  done := make(chan bool, 1)

  signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

  go func() {
    sig := <-sigs
    fmt.Println()
    fmt.Println(sig)
    done <- true
  }()

  fmt.Println("awaiting signal")
  <-done
  fmt.Println("exiting")
}
```

Note that hitting `ctrl` `c` is equivalent to sending `SIGINT`. `SIGTERM` is
usually sent from an operation system.

Also note that `SIGKILL` cannot be handled as it kills the process immediately.

### panic

`panic` does take care of the existing `defer` calls.

### signal.NotifyContext

```go
package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"time"
)

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	p, err := os.FindProcess(os.Getpid())
	if err != nil {
		log.Fatal(err)
	}

	// On a Unix-like system, pressing Ctrl+C on a keyboard sends a
	// SIGINT signal to the process of the program in execution.
	//
	// This example simulates that by sending a SIGINT signal to itself.
	if err := p.Signal(os.Interrupt); err != nil {
		log.Fatal(err)
	}

	select {
	case <-time.After(time.Second):
		fmt.Println("missed signal")
	case <-ctx.Done():
		fmt.Println(ctx.Err()) // prints "context canceled"
		stop()                 // stop receiving signal notifications as soon as possible.
	}

}
```

### os.Exit

- It does not cover any existing `defer` calls.
- It does stop all existing go routines.

### cmd

`cmd` creates a sub process instead of a sub-routine. Thus, when ending a parent
program, the sub process will not be cleaned up automatically and code has to be
written to handle that.

### Sprintf

##### Bytes

When bytes are included, casting to `string` is not necessary. That is, the
following should be used

```go
fmt.Sprintf("%s", byteslice)
```

instead of

```go
fmt.Sprintf("%s", string(byteslice))
```

##### Options

[String formatting options](https://gobyexample.com/string-formatting)

### Printf

- [A Deep Dive into fmt Printf in
  Golang](https://www.kosli.com/blog/a-deep-dive-into-fmt-printf-in-golang/)
  - format specifiers
    * `%t` - boolean values
  - escaping characters
    * `\a`  Alert or bell
    * `\b`  Backspace
    * `\t`  Horizontal tab
    * `\n`  New line
    * `\f`  Form feed
    * `\r`  Carriage return
    * `\v`  Vertical tab
    * `\'` Single quote (only in rune literals)
    * `\"` Double quote (only in string literals)
    * `\\` single slash
    * `%%` single percent
  - printing complex types
    * `%v` default representation of data
      - example
        - `[Mike David George]`
        - `{Michael 25}`
    * `%#v` Go's default representation of data
      - example
        - `[]string{"Mike", "David", "George"}`
        - `main.person{name:"Michael", age:25}`
    * `%+v` a representation between `%v` and `%#v`
      - example
        - `{name:Michael age:25}`
    * `%T` type of object

### Embed

A SQL file can be embedded for reading later

```go
import (
  _ "embed"
)

var (
  //go:embed sql/user_posts.sql
  queryUserPosts string
)

rows, err := db.Query(queryUserPosts, userID)
```

where `sql/user_post.sql` could be something like

```sql
SELECT users.email,
  posts.id,
  posts.title
FROM posts
  JOIN users ON posts.user_id = users.id
WHERE users.id = $1;
```

### Module

##### Testing a module locally

Use `replace` in `go.mod`

```go
module github.com/acme/foo

go 1.12

require (
	github.com/acme/bar v1.0.0
)

replace github.com/acme/bar => /path/to/local/bar
```

### Array, slice, reference and range

Reference: [Go Slices: usage and internals](https://go.dev/blog/slices-intro)

Declarations of array and slice are different.

```go
array := [3]int{1,2,3}
anotherArray := [...]int{1,2,3}
slice := []int{1,2,3}
anotherSlice := make([]int)
```

Array is a value type while slice is a reference type.

```go
s1 := []int{20}
s2 := s1
s2[0] = 60

if s1[0] != 60 {
  panic("")
}

a1 := [...]int{20}
a2 := a1
a2[0] = 60

if a1[0] != 20 {
  panic("")
}

fmt.Println("No panics")
```

Length and capacity of a slice

```go
len(slice)
cap(slice)
```

Note that capacity is the number of elements in the underlying array but
counting from the beginning position of the slice. A slice cannot be grown
beyond its capacity. Attempting to do so will cause a runtime panic.

Create a slice of `[]*Item` from array of `Item`

```go
var slice []*TodoItem
for i := range array {
  slice = append(slice, &array[i])
}
```

Note that the following does not work as value from `range` is a copied value
not a reference.

```go
var slice []*TodoItem
for _, v := range array {
  slice = append(slice, &v)
}
```

There are times that copy should be considered to allow release of large block
of memory sooner. If `Find` in the following example does not copy but simply
return a slice, the returned slice would keep a reference to the original byte
array which could hold a large file.

```go
var digitRegexp = regexp.MustCompile("[0-9]+")

func FindDigits(filename string) []byte {
    b, _ := ioutil.ReadFile(filename)
    return digitRegexp.Find(b)
}

func FindAndCopyDigits(filename string) []byte {
    b, _ := ioutil.ReadFile(filename)
    b = digitRegexp.Find(b)
    c := make([]byte, len(b))
    copy(c, b)
    return c
}
```

## Charm

### Bubbletea

#### Debugging with Delve

[Reference](https://github.com/charmbracelet/bubbletea#debugging-with-delve)

Start a headless debugger (due to no access to `stdin` and `stdout`)

```sh
$ dlv debug --headless .
```

Assuming the port used by the headless Open another terminal

```sh
dlv connect 127.0.0.1:34241
```

#### Logging

```go
if len(os.Getenv("DEBUG")) > 0 {
	f, err := tea.LogToFile("debug.log", "debug")
	if err != nil {
		fmt.Println("fatal:", err)
		os.Exit(1)
	}
	defer f.Close()
}
```

## Vs Rust

Reference: [Vercel - Why Turborepo is migrating from Go to
Rust](https://vercel.com/blog/turborepo-migration-go-rust)

Go's strength is network computing in data centers and it excels at this task,
powering these workloads at the world's largest scales. The
goroutine-per-request model, Context API, and the standard library inclusion of
server infrastructure is testament to this community focus.

Additionally, Go favors simplicity over expressiveness. A side effect of that
decision means more errors are caught at runtime where other languages might
catch them at compilation. With a service running in a data center, you can roll
back, fix, and roll forward at your convenience. But, when building software
that users install, the cost of each mistake is higher.

The Rust language and community has prioritized correctness over API
abstraction—a tradeoff that we care a lot about when working with:

- Process management
- Filesystems
- Other low level OS concepts
- Shipping software to our users' machines

This means additional complexity is surfaced into our codebase, but it's
necessary complexity for the problems we're trying to solve.

Rust's type system and safety features allow us to put guardrails in place in
our codebase where we need them. The language's expressiveness allows our
developers to encode constraints that catch errors at compile time rather than
in GitHub issues.

#### Example

Go's preference for simplicity at the filesystem was creating problems for us
when it came to file permissions. Go lets users set a Unix-style file permission
code: a short number that describes who can read, write, or execute a file.

While this sounds convenient, this abstraction does not work across platforms;
Windows actually doesn't have the precise concept of file permissions. Go ends
up allowing us to set a file permission code on Windows, even when doing so will
have no effect.

In contrast, Rust's explicitness in this area not only made things simpler for
us but also more correct. If you want to set a file permission code in Rust, you
have to explicitly annotate the code as Unix-only. If you don't, the code won't
even compile on Windows. This surfacing of complexity helps us understand what
our code is doing before we ever ship our software to users.

