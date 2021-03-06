
____

##### remove BOM characters in files

```sh
for f in $(grep $'\xEF\xBB\xBF' --include=\*.cs --include=\*.config --include=\*.js -rl .); do
	sed 's/\xEF\xBB\xBF//' "$f" > "$f".updated
	mv "$f".updated "$f"
done
```

##### replace words in a file

```sh
sed -i -e 's/IncorrectSpelling/CorrectSpelling/g' ./package.json
```

or

```sh
sed -i -e 's|IncorrectSpelling|CorrectSpelling|g' ./package.json
```

##### replace words in a file and create a new file

```sh
sed  's/IncorrectSpelling/CorrectSpelling/g' original.txt > new.txt
```

##### add multiple lines from a file after a specific pattern

```sh
sed -i -e "/some-pattern/r file.txt" working.txt
```

##### To extract some lines from a file

To extract 1st, 3rd, 5th, ... line from a file

```sh
sed -n 1~2p some.txt
```

To extract 2st, 5th, 8th, ... line from a file

```sh
sed -n 2~3p some.txt
```
