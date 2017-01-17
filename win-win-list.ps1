##### PREREQUISITES

param (
	[string]$target=$(throw "-target is required."),								# argument 1 is the log file to extract the list from
    [string]$dbg=$(),
	[string]$result=([io.fileinfo]$MyInvocation.MyCommand.Name).basename+".txt",	# result file name is e.g. script.txt
    [string]$workdir="."															# where to put the list
)
#if (!(Test-Path $workdir)){mkdir $workdir}											# if workdir does not exist create it

##### GIVEN

$reAccessDeniedSimple1="ERROR - Failed to get file permissions: (.*)$"
$reAccessDeniedSimple2="WARN - Access to the folder is denied: (.*)$"
$reAccessDeniedVSS1="^Access to the path '(.*)' is denied.$"    
$reAccessDeniedVSS2="^Could not find file '(.*)'.$" 
$rePathNotFound="Could not find a part of the path '(.*)'.$"

##### LOGIC

echo " `r`n Access denied: `r`n" > $workdir\$result

if ($dbg){  invoke-item $workdir\$result; echo "Created and opened. Press any key to continue";		$pressed=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 
			echo " `r`n Simple1: `r`n" >> $workdir\$result}																									#DBG

select-string -path $target $reAccessDeniedSimple1	| ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt   # for simple paths
Get-Content $workdir\tempresult.txt | Sort-Object	| Get-Unique >> $workdir\$result

if ($dbg){	invoke-item $workdir\tempresult.txt; echo "Simple1 done. Press any key to continue";	$pressed=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
			echo " `r`n Simple2: `r`n" >> $workdir\$result}																									#DBG

select-string -path $target $reAccessDeniedSimple2	| ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt   # for simple paths
Get-Content $workdir\tempresult.txt | Sort-Object	| Get-Unique >> $workdir\$result

if ($dbg){	invoke-item $workdir\tempresult.txt; echo "Simple2 done. Press any key to continue";	$pressed=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
			echo " `r`n VSS1: `r`n" >> $workdir\$result}																									#DBG

select-string -path $target $reAccessDeniedVSS1		| ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt   # for VSS paths
Get-Content $workdir\tempresult.txt | Sort-Object	| Get-Unique >> $workdir\$result

if ($dbg){	invoke-item $workdir\tempresult.txt; echo "VSS1 done. Press any key to continue";		$pressed=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
			echo " `r`n VSS2: `r`n" >> $workdir\$result}																									#DBG

select-string -path $target $reAccessDeniedVSS2		| ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt   # for VSS paths
Get-Content $workdir\tempresult.txt | Sort-Object	| Get-Unique >> $workdir\$result

if ($dbg){	invoke-item $workdir\tempresult.txt; echo "VSS2 done. Press any key to continue";		$pressed=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")}#DBG

echo " `r`n Could not find a part of the path: `r`n" >> $workdir\$result
select-string -path $target $rePathNotFound			| ForEach-Object {$_.Matches.Groups[1].Value} > $workdir\tempresult.txt   # for not found files
Get-Content $workdir\tempresult.txt | Sort-Object	| Get-Unique >> $workdir\$result

if ($dbg){invoke-item $workdir\tempresult.txt; echo "Not found done. Press any key to continue"; 	$pressed=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")}#DBG


# clean the mess up
rm $workdir\tempresult.txt

##### OUTPUT

# open the path in a default file browser
#invoke-item $workdir			# for sending
invoke-item $workdir\$result	# for reading
