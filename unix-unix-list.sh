#!/bin/bash

##### PREREQUISITES

target=$1							# argument 1 is the log file to extract the list from
result=`basename $0 | cut -f1 -d'.'`".txt"			# result file name is e.g. script.txt
workdir=./worktempdir						# where to put the list
if [ ! -d $workdir ];then mkdir $workdir;fi			# if workdir does not exist create it

##### LOGIC

textPermissionDenied="Can't open file:"
rePermissionDenied="[/](.*){,}"

# get list of files that face Permission Denied error and put the list into result file
echo "Permission denied:" > $workdir/$result
grep "$textPermissionDenied" $target | grep -Eo "$rePermissionDenied" | sort | uniq >> $workdir/$result
#xdg-open $workdir/$result; read -p "Permission denied done. Press enter to continue" #DBG

echo "" >> $workdir/$result
echo "Not found:" >> $workdir/$result
grep -Eo "$reNotFound" $target 	| sort 	| uniq | sed 's/ does not exist$//' >> $workdir/$result
#xdg-open $workdir/$result; read -p "Not found done. Press enter to continue" #DBG

# open the path in a default file browser
xdg-open $workdir #/$result
