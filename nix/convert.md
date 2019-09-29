##### To crop an image

```sh
convert -resize x16 -background transparent -gravity center -crop 16x16+0+0 original.png -flatten -colors 256 output.png
```

