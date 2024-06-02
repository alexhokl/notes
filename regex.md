- [Links](#links)
- [Basics](#basics)
  * [Metacharacters](#metacharacters)
  * [Named groups](#named-groups)
  * [Other examples](#other-examples)
____

## Links

- [Expresso](http://www.ultrapico.com/expresso.htm) The premier regular expression development tool for Windows
- [regular expression 101](https://regex101.com/) A regular expression tester 
- [myregextester](https://myregextester.com/index.php) A regular expression tester
- [RegexBuddy](http://www.regexbuddy.com/) A regular expression development tool for Windows
- [Regular Expression Examples](https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-examples)
- [RegExLib](http://regexlib.com/) A regular expression library
- [RegExr](https://regexr.com/) A regular expression tester with explanation

## Basics

### Metacharacters

#### Wildcard

- `.` - any single character
- `\s` - whitespace string
- `\S` - non-whitespace string
- `\d` - digit
- `\D` - non-digit
- `[a-z]` - lower case string
- `[A-Z]` - upper case string
- `[A-Za-z]` - alphabetical string
- `[A-Za-z0-9_]` - alpha-numeric string
- `\w` - alpha-numeric string
- `\W` - non-alpha-numeric string

#### Quantification

- `*` - zero or more occurrences of the preceding element (which implies
  optional)
- `?` - zero or one occurrence of the preceding element (which also implies
  optional)
- `+` - one or more occurrences of the preceding element
- `{2}` - exactly two occurrences of the preceding element
- `{2,}` - at least two occurrences of the preceding element
- `{2,4}` - two to four occurrences of the preceding element

#### Position

- `^` - beginning of a line
- `$` - end of a line

#### Operators

- `|` - or
- `()` - grouping (or referred as a capture group)

### Named groups

##### `(?<email>.*?)\[(?<provider>.*?)\]`

matches `"user@gmail.com[facebook]"`

where `email = "user@gmail.com"` and `provider = "facebook"`.

##### `~/message/(?<phoneNumber>\d+)/(?<itemName>\w+$)`

matches `"~/message/98765432/nexus"`

where `itemName = "nexus"` and `phoneNumber = "98765432"`

### Other examples

- `reali[sz]e` matches both British and American spelling of the word
- `<wind>` matches the whole word `wind`
- `\bwind\b` matches the whole word `wind`
- `[[:digit]]{4}` matches any 4 digits
- `[[:alpha]]{4}` matches any 4-character word
- `die?d` matches `did` or `died`
- `June|July` matches `June` or `July`
