
____

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

##### To select items in an array with a property containing a string

```sh
jq '.[] | select(.name | strings | test("search-term"))'
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

##### To count an json array

```sh
jq length
```

##### To concatenate properties in to a stringdefault

```sh
kubectl -n default get endpoints kubernetes -o json | \
  jq -r '(.subsets[0].addresses[0].ip + ":" + (.subsets[0].ports[0].port|tostring))'
```
