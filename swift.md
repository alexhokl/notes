
____

##### NSUserDefaults
```swift
// to save
var valueToSave = "someValue"
NSUserDefaults.standardUserDefaults().setObject(valueToSave, forKey: "preferenceName")

// to read
if let savedValue = NSUserDefaults.standardUserDefaults().stringForKey("preferenceName") {
  // Do something with savedValue
}
```
