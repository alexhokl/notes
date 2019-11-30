##### To extract links from Watch Later list

```js
arr=[];document.querySelectorAll('.yt-simple-endpoint.style-scope.ytd-playlist-video-renderer').forEach(v => arr.push('youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4" https://youtube.com'+ v.attributes["href"].value.slice(0, 20)));copy(arr);
```
