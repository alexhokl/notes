- [Accessibility](#accessibility)
  * [Links](#links)
- [Architecture](#architecture)
- [Browsers](#browsers)
- [Building](#building)
- [CSS](#css)
  * [Links](#links-1)
  * [Layout](#layout)
  * [SCSS](#scss)
  * [Tools](#tools)
- [Feature policy](#feature-policy)
- [Linters](#linters)
- [HTML5](#html5)
- [HTTP Headers](#http-headers)
- [Icons](#icons)
- [Local Storage](#local-storage)
- [ServiceWorker](#serviceworker)
- [UX Design](#ux-design)
- [Validation](#validation)
- [WebP](#webp)
____

## Accessibility

### Links

- [axe-core](https://www.npmjs.com/package/axe-core) - an accessibility testing
  engine for websites and other HTML-based user interfaces

## Architecture

- [web.dev](https://web.dev/)

## Browsers

- [Can I use](http://caniuse.com/)
- [What's the difference between “Normal Reload”, “Hard Reload”, and “Empty
  Cache and Hard Reload” in
  chrome?](http://stackoverflow.com/questions/14969315/whats-the-difference-between-normal-reload-hard-reload-and-empty-cache-a)

## Building

- [Tooling.Report](https://bundlers.tooling.report/)

## CSS

### Links

- [Modern CSS Solutions](https://moderncss.dev/)

### Layout

To make elements to show on the same line, apply the following to each element.

```css
float: left;
display: inline-block;
```

### SCSS

- There must be a space to separate `&` and class name.

### Tools

To add a class in chrome on-the-fly, use "plus" button in inspect mode.

## Feature policy

- [Feature Policy playground](https://featurepolicy.info/)

## Linters

- [The JavaScript Oxidation Compiler](https://oxc.rs/) - a JavaScript linter,
  parser, resolver and transformer written in Rust

## HTML5

- [DIVE INTO HTML5](http://diveintohtml5.info/)

## HTTP Headers

- [Using the Accept HEader to version your
  API](http://labs.qandidate.com/blog/2014/10/16/using-the-accept-header-to-version-your-api/)
- IFrame attack prevention
  [X-Frame-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options)

## Icons

- [IcoMoon](https://icomoon.io/)
- [veryicon](http://www.veryicon.com/)
- [opencontainers/artwork](https://github.com/opencontainers/artwork)

## Local Storage

- [livestorejs](https://github.com/livestorejs) - a Javascript library for local
  storage using SQLite

## ServiceWorker

- [Using ServiceWorker in Chrome
  today](https://jakearchibald.com/2014/using-serviceworker-today/)
- [The Offline Cookbook](https://jakearchibald.com/2014/offline-cookbook/)
- [jakearchibald/idb](https://github.com/jakearchibald/idb) an IndexedDB
  library

## UX Design

- [Discovery phase](https://www.uxapprentice.com/discovery/)
- [Design phase](https://www.uxapprentice.com/design/)

## Validation

- [Client-side form
  validation](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Form_validation)

## WebP

To use WebP and make JPEG as backup

```html
<picture>
  <source srcset="img/image.webp" type="image/webp">
  <source srcset="img/image.jpg" type="image/jpeg">
  <img src="img/image.jpg" alt="Alt Text!">
</picture>
```

