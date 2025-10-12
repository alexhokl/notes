
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

or

```sh
jq '.[] | select(.name | contains("search-term"))'
```

##### To select items in an array not with a property containing a string

```sh
jq '.[] | select(.name | strings | test("search-term" | not))'
```

##### To show multiple properties in an array

```sh
jq '.[] | { name: .some-property, display: .some-other-property }'
```

##### To show only a particular item in an array

```sh
jq '.[6]'
```

##### To show the last 5 entries in an array

```sh
jq '.[-5:][] | .property-name'
```

##### To show a value without double quotes

```sh
jq -r '.[] | .property-name'
```

##### To show keys (property names) of an object

```sh
jq 'keys'
```

The above command show keys of the root level.

Note that the result is a json array.


To show keys of the first item in an array of objects

```sh
cat logs.json | jq '.[0] | keys'
```

##### To count an json array

```sh
jq length
```

##### To concatenate properties in to a string

```sh
kubectl -n default get endpoints kubernetes -o json | \
  jq -r '(.subsets[0].addresses[0].ip + ":" + (.subsets[0].ports[0].port|tostring))'
```

##### To concatenate a simple array to string with delimiters

```sh
jq '.names | join(",")'
```

##### To use environment variables

The trick is to use double quotes to wrap the query

```sh
jq -r ".ipRules | .[] | select(.ipAddressOrRange==\"$1\") | .ipAddressOrRange"
```
