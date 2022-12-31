- [To compress](#to-compress)
- [To decompress](#to-decompress)
____

### To compress

```sh
pigz file-name-to-compress.txt
```

The file will be renamed as `file-name-to-compress.txt.gz`.

### To decompress

```sh
unpigz file-name-to-compress.txt.gz
```

### To compress a directory

```sh
tar --use-compress-program="pigz -k " -cf some_directory.tar.gz some_directory/
```

Note that hidden files are included.
