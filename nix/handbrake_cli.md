
____

##### To encode into H.264

```sh
HandBrakeCLI -o encoded.mp4 -i source.avi -e x264 -q 22 -B 160
```

##### To encode into H.264 with all audio track

```sh
HandBrakeCLI -o encoded.mp4 -i source.avi -e x264 -q 22 -B 160 --all-audio
```

##### To encode into H.264 with only the first audio track

```sh
HandBrakeCLI -o encoded.mp4 -i source.avi -e x264 -q 22 -B 160 --first-audio
```
