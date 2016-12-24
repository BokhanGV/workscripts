#!/bin/bash

##### PREREQUISITES

target=$1							# argument 1 is the log file to extract the list from
result=`basename $0 | cut -f1 -d'.'`"-list.txt"		# result file name is e.g. script-list.txt
workdir=./worktempdir						# where to put the list
if [ ! -d $tempdir ]; then
	mkdir $workdir						# if workdir does not exist create it
fi

##### LOGIC

# get list of files that face Permission Denied error and put the list into result file
grep "Can't open file:" $target | grep -Eo "[/][a-zA-Z0-9.,\ _-'\"\!@#$%^&*()\-+]{,}" | sort | uniq > $workdir/$result

## TODO files not found

# open the path in a default file browser
xdg-open $workdir #/$result
