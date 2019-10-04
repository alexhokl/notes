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
