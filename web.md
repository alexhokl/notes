- [Web](#web)
    + [Architecture](#architecture)
    + [Browsers](#browsers)
    + [Tools](#tools)
    + [HTML5](#html5)
    + [UX Design](#ux-design)
    + [ServiceWorker](#serviceworker)
    + [HTTP Headers](#http-headers)
    + [Icons](#icons)
    + [WebP](#webp)
    + [CSS](#css)
    + [Accessibility](#accessibility)
____

# Web

### Architecture

- [web.dev](https://web.dev/)

### Browsers

- [Can I use](http://caniuse.com/)
- [What's the difference between “Normal Reload”, “Hard Reload”, and “Empty Cache and Hard Reload” in chrome?](http://stackoverflow.com/questions/14969315/whats-the-difference-between-normal-reload-hard-reload-and-empty-cache-a)

### Tools

- [Tooling.Report](https://bundlers.tooling.report/)

### HTML5

- [DIVE INTO HTML5](http://diveintohtml5.info/)

### UX Design

- [Discovery phase](https://www.uxapprentice.com/discovery/)
- [Design phase](https://www.uxapprentice.com/design/)

### ServiceWorker

- [Using ServiceWorker in Chrome today](https://jakearchibald.com/2014/using-serviceworker-today/)
- [The Offline Cookbook](https://jakearchibald.com/2014/offline-cookbook/)

### HTTP Headers

- [Using the Accept HEader to version your API](http://labs.qandidate.com/blog/2014/10/16/using-the-accept-header-to-version-your-api/)
- IFrame attack prevention [X-Frame-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options)

### Icons

- [IcoMoon](https://icomoon.io://icomoon.io/)
- [veryicon](http://www.veryicon.com/)

### WebP

To use WebP and make JPEG as backup

```html
<picture>
  <source srcset="img/image.webp" type="image/webp">
  <source srcset="img/image.jpg" type="image/jpeg">
  <img src="img/image.jpg" alt="Alt Text!">
</picture>
```

### CSS

#### Layout

To make elements to show on the same line, apply the following to each element.

```css
float: left;
display: inline-block;
```

#### SCSS

- There must be a space to separate `&` and class name.

#### Tools

To add a class in chrome on-the-fly, use "plus" button in inspect mode.

### Accessibility

#### Links

- [axe-core](https://www.npmjs.com/package/axe-core) - an accessibility testing
  engine for websites and other HTML-based user interfaces
