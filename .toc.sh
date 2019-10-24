#!/bin/bash

depth=3
delimiter=____

temp_dir=$(mktemp -d)

for f in $(find . -name '*.md'); do
	line=$(grep $delimiter -n $f | head -n 1)
	num=0
	if [ -n "$line" ]; then
		num=$(echo $line | cut -d ':' -f 1)
	fi
	count=$(wc -l $f | awk '{ print $1 }')
	content_count=$(($count - $num))

	filename=$temp_dir/${f/.\//}
	dir=$(dirname $filename)

	if [ ! -d "$dir" ]; then
		mkdir -p $dir
	fi

	markdown-toc --maxdepth $depth $f > $filename
	echo "" >> $filename
	echo $delimiter >> $filename
	echo "" >> $filename
	tail -n $content_count $f >> $filename
	mv $filename $f
done

rm -rf $temp_dir
