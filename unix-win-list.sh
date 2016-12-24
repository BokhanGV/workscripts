#!/bin/bash

##### PREREQUISITES

target=$1					# argument 1 is the log file to extract the list from
result=`basename $0 | cut -f1 -d'.'`"-list.txt"	# result file name is e.g. script-list.txt
workdir=~/worktempdir				# where to put the list
if [ ! -d $tempdir ]; then
	mkdir $workdir				# if workdir does not exist create it
fi

##### LOGIC

tVSS="Access to the path"
reVSS="[\\]GLOBALROOT[\\]Device[\\]HarddiskVolumeShadowCopy[0-9]{,}[\\][a-zA-Z0-9.,\ _-'\"\!@#$%^&*()\-+]{,}[\']"
tSTC="Could not find file"
reSTC="[\\]STC_SnapShot_Volume_[0-9]{,}_[0-9]{,}[\\][a-zA-Z0-9.,\ _-'\"\!@#$%^&*()\-+]{,}[\']"
tSimple="ERROR - System.IO.DirectoryNotFoundException: Could not find a part of the path "
reSimple="[A-Z]{1}[:][\\][a-zA-Z0-9.,\ _-'\"\!@#$%^&*()\-+]{,}[\']"

# get list of files that face Permission Denied error and put the list into result file
grep "$tVSS" $target 	| grep -Eo "$reVSS" 	| uniq | awk '1' RS='.\n' >  $workdir/$result	# for VSS    paths
grep "$tSTC" $target 	| grep -Eo "$reSTC" 	| uniq | awk '1' RS='.\n' >> $workdir/$result	# for STC VSS paths
grep "$tSimple" $target	| grep -Eo "$reSimple"  | uniq | awk '1' RS='.\n' >> $workdir/$result	# for simple paths

## TO DO

# open the path in a default file browser
xdg-open $workdir #/$result_file
