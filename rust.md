- [Commands](#commands)
- [Language](#language)
  * [Declarations](#declarations)
  * [Control flow](#control-flow)
  * [Compound data type](#compound-data-type)
  * [Packages, crates and modules](#packages-crates-and-modules)
  * [Collections](#collections)
  * [String and string slice](#string-and-string-slice)
  * [Hash map](#hash-map)
  * [Others](#others)
____

## Commands

##### To create a new package

```sh
cargo new package_name
```

This will create package in path `./package_name`.

```sh
cargp init
```

This will create a new package in the currect directory instead. The current
directory name will be used as the package name.

Both commands create a `git` respository by default.

##### To compile and build an executable

```sh
rustc main.rs
```

If `Cargo.toml` exists,

```sh
cargo build
```

where executable `./main` will be created

##### To check if there is any compilation errors with producing a build

```sh
cargo check
```

##### To execute a program

```sh
cargo run
```

To run with arguments

```sh
cargo run 123 456
```

## Language

#### Common libraries

- `std::env`

### Declarations

##### Immutable variables by default

Declaration `let text:String = "abc"` is immutable by default.

To modify variable, declare it like `let mut text:String = "abc"`.

##### Un-used variable

By adding underscore

```rust
let _result = io::stdin().read_line(&mut guess);
```

##### Constant

```rust
const NAME_CONVENTION: String = "prefix_";
```

Note that type must be declared.

### Control flow

##### Loop

```rust
loop {
  println!("this loop won't quit!")
}
```

To return a value

```rust
let mut counter = 0;
let reuslt = loop {
  count += 1;
  if counter == 5 {
    break counter;
  }
};
```

##### While loop

```rust
let mut counter = 0;
while counter == 5{
  count += 1;
};
```

##### For loop

```rust
let a = [10, 20, 30];
for num in a.iter() {
  println!("number: {}", num);
};
```

##### One-liner if

```rust
let condition = true;
let number = if condition { 1 } else { 0 };
```

### Compound data type

##### Tuple

```rust
let key_value = ("KEY", 10);
let key = key_value.0
let value = key_value.1
```

##### Array

```rust
let error_codes = [400, 401, 403, 409, 500];
let conflict = error_codes[3];
```

##### Enum

```rust
enum IpAddressVersion{
  V4(u8, u8, u8, u8),
  V6(String),
}

impl IpAddressVersion {
  fn pretty_print(&self) {
    match self {
      IpAddressVersion::V4(a, b, c, d) => {
        println!("{}.{}.{}.{}", a, b, c, d);
      },
      IpAddressVersion::V6(addr) => {
        println!("{}", addr);
      }
    }
  }
}

fn main() {
  let localhost = IpAddressVersion::V4(127, 0, 0, 0);
  let remote = IpAddressVersion::V6(String::from("fe80::42:dfff:fed6:9bb0"));
  localhost.pretty_print();
  remote.pretty_print();
}
```

Note that `match` statement must exhause all possible values.

There are no `null` in Rust and `Option<T>` is the way to indicate the
possibility of having no value.

```rust
fn main() {
    let x: i8 = 5;
    let y: Option<i8> = Some(5);
    let sum = x + y.unwrap_or(0);
    println!("{}", sum);
}
```

```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
  match x {
    None => None,
    Some(i) => Some(i + 1),
  }
}
```

To have a default case

```rust
fn pretty_print(x: Option<i32>) {
  match x {
    Some(3) => {
      println!("it is three. you got it!");
    },
    Some(i) => {
      println!("it is not {}. it is another value", i);
    },
    _ => (),
  }
}
```

##### Structure

```rust
struct User {
  username: String,
  email: String,
  age: u16,
  active: bool,
}

impl User {
    fn print(&self) {
        println!("{}", self.username);
        println!("{}", self.email);
        println!("{}", self.age);
        println!("{}", self.active);
    }

    fn build(username: String, email: String, age: u16, active: bool) -> User {
        User {
            username,
            email,
            age,
            active,
        }
    }
}

fn main() {
    let user1 = User {
        username: String::from("John"),
        email: String::from("john@mail.com"),
        age: 30,
        active: true,
    };

    let user2 = User {
        username: String::from("Jane"),
        email: String::from("jane@mail.com"),
        ..user1
    };

    user2.print();

    let user3 = User::build(
        String::from("doe"),
        String::from("doe@mail.com"),
        30,
        true,
    );
    user3.print();
}
```

### Packages, crates and modules

- each package
  - zero or multiple binary crates
    - `main.rs` is a binary crate
    - each `.rs` file in `bin` directory is a binary crate
  - zero or one library crate
    - `lib.rs` is a library crate
- a package can be a binary or a bunch of source code
- each crate contains a root module and named as `crate`
- module is defined by `mod`
- modules can be nested and submodules are private to root module by default
  - `pub` is needed to allow access
- the first level of submodules are define in the same directrory as `lib.rs`
  - sumodules of a first level submodule are in a directory with the name of the
    first level submodule
    - example
      - `lib.rs`
      - `first_module.rs`
      - `first_module/second_module.rs`
- reference example
  - `package_name::first_module::second_module::*`

### Collections

##### Vectors

```rust
let mut v1: Vec<i32> = Vec::new();
v1.push(99);

let v2 = vec![1, 2, 3];
let index = 2;
match v2.get(index) {
  Some(i) => println!("the value is {}", i),
  None => println!("invalid index"),
};

for i in &mut v1 {
  *i += 2;
}
for i in &mut v1 {
  println!("value is {}", i);
}
for i in &v2 {
  println!("value is {}", i);
}

```

### String and string slice

```rust
let s1: String = String::new();
let s2: &str = "hello";
let s3: String = String::from("world");

let mut s4: String = s2.to_string();
s4.push(' ');
s4.push_str("world");

let s5 = String::from("!");
let s6: String = s4 + &s5; // s6 borrowed s4 and s4 cannot be referenced anymore
let s7 = s2.to_string();
let s8 = format!("{} {}", s7, s3);

for b in s8.bytes() {
  println!("{}", b);
}
for c in s8.chars() {
  println!("{}", c);
}
```

### Hash map

It uses to store key-value pairs.

```rust
use std::collections::HashMap;

fn main() {
    // type specification is not required
    // as it could be inferred from the the first insert usage
    let mut scores = HashMap::new();

    let blue = String::from("Blue");

    scores.insert(blue, 10);    // blue cannot be referenced anymore since it has been borrowed by scores
    scores.insert(String::from("Yellow"), 50);

    let blue = String::from("Blue");
    let score: Option<&i32> = scores.get(&blue);
    println!("{:?}", score);

    // overwrites a value of a key
    scores.insert(String::from("Blue"), 25);

    // this does nothing as key yellow exists
    scores.entry(String::from("Yellow")).or_insert(99);

    // writes a value of a key if it not exists
    let red_score: &mut i32 = scores.entry(String::from("Red")).or_insert(99);

    // updates value of red in scores
    *red_score += 1;

    // iterating over a hashmap
    for (key, value) in &scores {
        println!("{}: {}", key, value);
    }
}
```

### Others

##### String interpolation

```rust
println!("hello {}", name)
```

##### Function

`return` keyword and `;` can be omitted if it is the last statement of
a function.

```rust
fn sum(a: i32, b: i32) -> i32 {
  a + b
}
```

##### Result

`std::result::Result` is an `enum` with generic types of `Ok<T>` and `Err(E)`.
Note that Rust does not have exceptions but it serves panic.

###### To handle error as panic

```rust
let user_input = String::new();
let user_number_input: u32 = user_input.parse().expect("Please type a number!");
println!("The number: {}", user_number_input);
```

###### To handle error and continue

```rust
let user_input = String::new();
let user_number_input: u32 = match user_input.parse() {
    Ok(num) => num,
    Err(_) => {
        println!("Please enter a number");
        return;
    }
};
```

where `match` is for `enum` handling.

###### To bubble error to caller

```rust
fn parse(str: String) -> Result<i32, Error> {
  let user_number_input: u32 = match user_input.parse()?;
  user_number_input
}
```

Note that, to use `?`, the enclosed function must return either `Result` or
`Option`.

###### To not handle error

```rust
let user_input = String::new();
let user_number_input: u32 = user_input.parse().unwrap();
println!("The number: {}", user_number_input);
```

###### To write a function with potential error

```rust
fn halves_if_even(i: i32) -> Result<i32, Error> {
    if i % 2 == 0 {
        Ok(i / 2)
    } else {
        Err(/* something */)
    }
}
```
