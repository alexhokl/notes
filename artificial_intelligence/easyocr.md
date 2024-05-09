- [Links](#links)
- [Commands](#commands)
____

# Links

- [EasyOCR](https://github.com/JaidedAI/EasyOCR)
- [documentation](https://www.jaided.ai/easyocr/)

# Commands

##### To perform OCR with English

```sh
easyocr -l en -f image.jpg --detail=0 --gpu=True
```

or with detail of coordinates of text locations

```sh
easyocr -l en -f image.jpg --detail=1 --gpu=True
```
