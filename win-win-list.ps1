##### PREREQUISITES

param (
	[string]$target=$(throw "-target is required."),				# argument 1 is the log file to extract the list from
	[string]$result=([io.fileinfo]$MyInvocation.MyCommand.Name).basename+".txt",	# result file name is e.g. script-list.txt
    	[string]$workdir="..\worktempdir"						# where to put the list
)
If (!(Test-Path $workdir)){mkdir $workdir}                                      	# if workdir does not exist create it

##### LOGIC

$reAccessDeniedSimple1="ERROR - Failed to get file permissions: (.*)$"
$reAccessDeniedSimple2="WARN - Access to the folder is denied: (.*)$"
$reAccessDeniedVSS1="^Access to the path '(.*)' is denied.$"	
$reAccessDeniedVSS2="^Could not find file '(.*)'.$"	
$rePathNotFound="ERROR - System.IO.DirectoryNotFoundException: Could not find a part of the path (.*)$"

# get list of files that face Access Denied error and put the list into result file
echo "Access denied:" > $workdir\$result
select-string -path $target $reAccessDeniedSimple1| ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt	# for simple paths
Get-Content $workdir\tempresult.txt | Sort-Object | Get-Unique >> $workdir\$result

select-string -path $target $reAccessDeniedSimple2| ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt	# for simple paths
Get-Content $workdir\tempresult.txt | Sort-Object | Get-Unique >> $workdir\$result

elect-string -path $target $reAccessDeniedVSS1	  | ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt	# for VSS paths
Get-Content $workdir\tempresult.txt | Sort-Object | Get-Unique >> $workdir\$result

select-string -path $target $reAccessDeniedVSS2   | ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt	# for VSS paths
Get-Content $workdir\tempresult.txt | Sort-Object | Get-Unique >> $workdir\$result

echo "" >> $workdir\$result
echo "Could not find a part of the path:" >> $workdir\$result
select-string -path $target $rePathNotFound	  | ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt	# for not found files
Get-Content $workdir\tempresult.txt | Sort-Object | Get-Unique >> $workdir\$result

rm $workdir\tempresult.txt

# open the path in a default file browser
invoke-item $workdir #\$result
