##### To list an array

```sh
jq '.[]'
```

##### To show a property in an array

```sh
jq '.[] | .your-property-name'
```

##### To select items in an array with a property equals to a particular value

```sh
jq '.[] | select(.your-property-name=="some-string")'
```

##### To show multiple properties in an array

```sh
jq '.[] | { name: .some-property, display: .some-other-property }'
```

##### To show only a particular item in an array

```sh
jq '.[6]'
```

##### To show a value without double quotes

```sh
jq -r '.[] | .property-name'
```

##### To show keys (property names) of an object

```sh
jq 'keys'
```

Note that the result is a json array
