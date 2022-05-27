- [Commands](#commands)
- [Language](#language)
  * [Declarations](#declarations)
  * [Control flow](#control-flow)
  * [Compound data type](#compound-data-type)
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
