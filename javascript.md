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
