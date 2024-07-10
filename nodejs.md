- [Links](#links)
- [Initialising a module](#initialising-a-module)
____

### Links

-	[Introduction to queues in node.js](https://blog.yld.io/2016/05/10/introducing-queues/)
-	[10 Best Practices for Writing Node.js REST APIs](https://medium.com/the-node-js-collection/10-best-practices-for-writing-node-js-rest-apis-7643a7765cd)
-	[ECMAScript 2015 (ES6) and beyond](https://nodejs.org/en/docs/es6/)
-	[Nodejs Express Mongoose Demo](https://github.com/madhums/node-express-mongoose-demo)
-	[How to test your MongoDB models under Node & Express](https://www.terlici.com/2014/09/15/node-testing.html)
-	[Best practices for Express app structure](https://www.terlici.com/2014/08/25/best-practices-express-structure.html)
-	[Uploading files locally with Node & Express](https://www.terlici.com/2015/05/16/uploading-files-locally.html)
- [Graceful shutdown with Node.js and Kubernetes](https://blog.risingstack.com/graceful-shutdown-node-js-kubernetes/)

### Initialising a module

##### to say yes to all questions

```sh
npm init --yes
```

##### To init with a config (asumming `$HOME/.npm-init.js` is setup)

```sh
npm init
```

install depenedency and development dependency
```sh
npm i -S express
npm i -D ava
```

##### To lock down version of dependencies

```sh
npm shrinkwrap
```

##### To remove cache

```sh
npm cache clean
```

##### To list local installed modules

```sh
npm list
```

or to list the packages but not its dependencies,

```sh
npm list --depth=0
```
##### To list global installed modules

```sh
npm list -g
```

or to list the packages but not its dependencies,

```sh
npm list --depth=0 -g
```

#### To list outdated packages

```sh
npm outdated
```
