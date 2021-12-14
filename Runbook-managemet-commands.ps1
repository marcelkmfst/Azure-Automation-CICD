#Working Area to check how Runbooks are imported manually. 


$rg="RG-AutomationCICD"
$aa="Aut-Account-CICD"
$published # check how to add condition for published 

$type # find an way to set the target type based on the file extension



$runbooks=(Get-ChildItem -Path .\runbooks\)
$runbooknamestring=$runbooks.name
ForEach  ($runbook in $runbooknamestring)
{
    Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type PowerShell -Published
} 


 
