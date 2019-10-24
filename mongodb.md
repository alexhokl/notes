
____

to remove a field from a collection
```js
db.examples.update({}, { $unset: {'tags.words':1} }, { multi: true });
```

to list a collection with certain fields
```js
db.exmaples.find({}, { name:1, source:1 });
```
