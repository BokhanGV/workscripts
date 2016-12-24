#!/bin/bash

##### PREREQUISITES

target=$1					# argument 1 is the log file to extract the list from
result=`basename $0 | cut -f1 -d'.'`".txt"	# result file name is e.g. script-list.txt
workdir=./worktempdir				# where to put the list
if [ ! -d $workdir ];then mkdir $workdir;fi	# if workdir does not exist create it

##### LOGIC

textAccessDeniedSimple1="ERROR - Failed to get file permissions:"
textAccessDeniedSimple2="WARN - Access to the folder is denied:"
textAccessDeniedSimple3="^Access to the path"    
textAccessDeniedVSS1="^Access to the path"    
textAccessDeniedVSS2="^Could not find file" 
textPathNotFound="ERROR - System.IO.DirectoryNotFoundException: Could not find a part of the path"

reAccessDeniedSimple="[A-Z]{1}[:][\\](.*){,}[\']"
reAccessDeniedVSS="[\\]GLOBALROOT[\\]Device[\\]HarddiskVolumeShadowCopy[0-9]{,}[\\](.*){,}[\']"    
reStorageCraft="[\\]STC_SnapShot_Volume_[0-9]{,}_[0-9]{,}[\\](.*){,}[\']"
rePathNotFound="[\'](.*){,}[\']"

# get list of files that face Permission Denied error and put the list into result file

echo "Access denied:" > $workdir/$result
#xdg-open $workdir/$result; read -p "Created and opened. Press enter to continue" #DBG

grep "$textAccessDeniedSimple1" $target	| grep -Eo "$reAccessDeniedSimple" 	| sort | uniq | awk '1' RS='.\n' >> $workdir/$result	# for simple paths
grep "$textAccessDeniedSimple2" $target	| grep -Eo "$reAccessDeniedSimple" 	| sort | uniq | awk '1' RS='.\n' >> $workdir/$result	# for simple paths
grep "$textAccessDeniedSimple3" $target	| grep -Eo "$reAccessDeniedSimple" 	| sort | uniq | awk '1' RS='.\n' >> $workdir/$result	# for simple paths
#xdg-open $workdir/$result; read -p "Simple done. Press enter to continue" #DBG

grep "$textAccessDeniedVSS1" 	$target	| grep -Eo "$reAccessDeniedVSS"		| sort | uniq | awk '1' RS='.\n' >> $workdir/$result	# for VSS paths
grep "$textAccessDeniedVSS2" 	$target	| grep -Eo "$reAccessDeniedVSS"		| sort | uniq | awk '1' RS='.\n' >> $workdir/$result	# for VSS paths
grep "$textAccessDeniedVSS2" 	$target	| grep -Eo "$reStorageCraft"		| sort | uniq | awk '1' RS='.\n' >> $workdir/$result	# for VSS paths
#xdg-open $workdir/$result; read -p "VSS done. Press enter to continue" #DBG

echo "" >> $workdir/$result
echo "Could not find a part of the path:" >> $workdir/$result
grep "$textPathNotFound" 		$target	| grep -Eo "$rePathNotFound"  	| sort | uniq | cut -c2- | awk '1' RS='.\n' >> $workdir/$result	# for not found paths
#xdg-open $workdir/$result; read -p "Not found done. Press enter to continue" #DBG

## TO DO

# open the path in a default file browser
xdg-open $workdir #/$result
