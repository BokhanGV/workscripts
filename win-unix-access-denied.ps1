##### PREREQUISITES

param (
	[string]$target=$(throw "-target is required."),				# argument 1 is the log file to extract the list from
	[string]$result=([io.fileinfo]$MyInvocation.MyCommand.Name).basename+".txt",	# result file name is e.g. script-list.txt
    [string]$workdir="..\worktempdir"							# where to put the list
)
If (!(Test-Path $workdir)){mkdir $workdir}

##### LOGIC

# get list of files that face Permission Denied error and put the list into result file
select-string -path $target "Can't open file:([/]\s*\w*)*" | select matches | Out-File $workdir\tempfile.txt
select-string -path $workdir\tempfile.txt "[/]\s*\w*([/]\s*\w*)*" | select matches | Out-File $workdir\$result 

Remove-Item $workdir\tempfile.txt

# open the path in a default file browser
invoke-item $workdir\ #$result

##### DEBUG

#echo ""
#echo "target:  $target"
#echo "result:  $result"
#echo "workdir: $workdir"
#echo ""
