#!/bin/bash
target_file=$1
result_file=`basename $0 | cut -f1 -d'.'`"-list.txt"
tempdir=./worktempdir
if [ ! -d $tempdir ]; then
	mkdir $tempdir
fi

cat $target_file | grep "Can't open file:" | grep -Eo "[/]+[a-zA-Z0-9.,\ _-'#&()]{,}" | uniq > $tempdir/$result_file

nemo $tempdir