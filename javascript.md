- [Links](#links)
____

### Links

- [ECMAScript 6 compatibility table](http://kangax.github.io/compat-table/es6/)
- [eslint rules from Airbnb](https://github.com/airbnb/javascript/tree/master/packages/eslint-config-airbnb-base/rules)

##### To inject jQuery into Chrome deugging console

```js
var jq = document.createElement('script');
jq.src = "https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js";
document.getElementsByTagName('head')[0].appendChild(jq);

jQuery.noConflict();
```

##### array

to find unique items in an array

```js
var uniquePredicate = function (value, index, self) {
  return self.indexOf(value) === index;
}
var uniqueDocuments = allDocuments.filter(uniquePredicate);
```

##### double and triple equality

```js
null == undefined   // true
null === undefined  // false
'' == '0'          // false
0 == ''            // true
0 == '0'           // true
false == 'false'   // false
false == '0'       // true
false == undefined // false
false == null      // false
null == undefined  // true
" \t\r\n " == 0    // true
```

##### Examples on triple-equal-sign in Javascript. Note that all the code return 3.

```js
var f1 = function() {
  var abc;
  if (abc === undefined) {
    return 1;
  }
  if (abc === null) {
    return 3;
  }
};

var f2 = function() {
  if (abc === null) {
    return 1;
  }
  if (abc === undefined) {
    return 3;
  }
}

var f3 = function() {
  var array = [1, 2];
  if (array[10] === null) {
    return 1;
  }
  if (array[10] === undefined) {
    return 3;
  }
}
```

##### Example on automatic semi-colon insertion in Javascript

```js
var h1 = function() {
  return {
    abc: '123'
  }
}

var h2 = function() {
  return
  {
    abc: '123'
  };
}

// h1 returns an object named 'abc'
// h2 returns 'undefined'
```
