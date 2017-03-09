#### Variables

###### `(?<email>.*?)\[(?<provider>.*?)\]`

matches `"user@gmail.com[facebook]"`

where `email = "user@gmail.com"` and `provider = "facebook"`.

##### `~/message/(?<phoneNumber>\d+)/(?<itemName>\w+$)`

matches `"~/message/98765432/nexus"`

where `itemName = "nexus"` and `phoneNumber = "98765432"`

