##### PREREQUISITES

param (
	[string]$target=$(throw "-target is required."),				# argument 1 is the log file to extract the list from
	[string]$result=([io.fileinfo]$MyInvocation.MyCommand.Name).basename+".txt",	# result file name is e.g. script-list.txt
    	[string]$workdir="..\worktempdir"						# where to put the list
)
If (!(Test-Path $workdir)){mkdir $workdir}                                         	# if workdir does not exist create it

##### LOGIC

$rePermissionDenied="Can't open file:(.*)$"

# get list of files that face Permission Denied error and put the list into result file
echo "Permission denied:" > $workdir\$result
select-string -path $target $rePermissionDenied   | ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt 
Get-Content $workdir\tempresult.txt | Sort-Object | Get-Unique >> $workdir\$result

## TODO files not found

rm $workdir\tempresult.txt

# open the path in a default file browser
invoke-item $workdir\ #$result
