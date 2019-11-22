##### To extract links from Watch Later list

```js
document.querySelectorAll('.yt-simple-endpoint.style-scope.ytd-playlist-video-renderer').forEach(v => console.info(v.attributes["href"]));
```
