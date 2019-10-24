- [Links](#links)
____

### Links

-	[Expresso](http://www.ultrapico.com/expresso.htm) The premier regular expression development tool for Windows
-	[myregextester](https://myregextester.com/index.php) A regular expression tester
-	[RegexBuddy](http://www.regexbuddy.com/) A regular expression development tool for Windows
-	[Regular Expression Examples](https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-examples)
-	[RegExLib](http://regexlib.com/) A regular expression library

#### Variables

###### `(?<email>.*?)\[(?<provider>.*?)\]`

matches `"user@gmail.com[facebook]"`

where `email = "user@gmail.com"` and `provider = "facebook"`.

##### `~/message/(?<phoneNumber>\d+)/(?<itemName>\w+$)`

matches `"~/message/98765432/nexus"`

where `itemName = "nexus"` and `phoneNumber = "98765432"`
