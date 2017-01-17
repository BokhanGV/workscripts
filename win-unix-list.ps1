##### PREREQUISITES

param (
	[string]$target=$(throw "-target is required."),								# argument 1 is the log file to extract the list from
    [string]$dbg=$(),
	[string]$result=([io.fileinfo]$MyInvocation.MyCommand.Name).basename+".txt",	# result file name is e.g. script.txt
    [string]$workdir="."															# where to put the list
)
#if (!(Test-Path $workdir)){mkdir $workdir}											# if workdir does not exist create it

##### GIVEN

$rePermissionDenied="Can't open file:(.*)$"
$reNotFound="/(.*) does not exist$"

##### LOGIC

echo " `r`n Permission denied: `r`n" > $workdir\$result
if ($dbg){invoke-item $workdir\$result; echo "Created and opened. Press any key to continue";		$pressed=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")} #DBG

select-string -path $target $rePermissionDenied		| ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt   # for Permission Denied
Get-Content $workdir\tempresult.txt | Sort-Object	| Get-Unique >> $workdir\$result
if ($dbg){invoke-item $workdir\$result; echo "Permission denied done. Press any key to continue";	$pressed=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")} #DBG

echo " `r`n Could not find a part of the path: `r`n" >> $workdir\$result
select-string -path $target $reNotFound				| ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt   # for not found files
Get-Content $workdir\tempresult.txt | Sort-Object	| Get-Unique >> $workdir\$result
if ($dbg){invoke-item $workdir\$result; echo "Not found done. Press any key to continue";			$pressed=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")} #DBG

# clean the mess up
rm $workdir\tempresult.txt

##### OUTPUT

# open the path in a default file browser
#invoke-item $workdir			# for sending
invoke-item $workdir\$result	# for reading
