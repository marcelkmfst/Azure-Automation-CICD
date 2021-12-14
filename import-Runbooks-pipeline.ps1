#Script to be executed as part of the pipeline run



$rg="RG-AutomationCICD"
$aa="Aut-Account-CICD"
$published = 'true'

$type # find an way to set the target type based on the file extension

# check if 
# e.g. if $runbook = *.ps1 $filetype $Type = Powershell


$runbooks=(Get-ChildItem -Path .\Runbooks\)
$runbooknamestring=$runbooks.name
ForEach  ($runbook in $runbooknamestring)
{
if ($published -eq 'true') {  ### if $published variable is set to true, the Import Cmdlet will be executed with "-published" option, else without 
        if ($runbook -like '*.ps1') 
        {
            Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type PowerShell -Published
        }
        elseif ($runnbok -like '*.graphrunbook') 
        {
            Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type GraphicalPowerShell -Published
        }
        elseif ($runbook -like '*.py') 
        {
            Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type Python2 -Published
        }
        elseif ($runbook -like 'workflow*') # Powershell worklfows also have ps1 filetypeextension, so we can´t use ps1 to identify type, the if condition checks if the filename starts with "workflow"
        {
            Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type PowerShellWorkflow -Published
        }
        else 
        {
            Write-Output "No valid Runbook found"
        }
    }
else {
    {
        Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type PowerShell
    }
    elseif ($runnbok -like '*.graphrunbook') 
    {
        Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type GraphicalPowerShell 
    }
    elseif ($runbook -like '*.py') 
    {
        Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type Python2 
    }
    else 
    {
        Write-Output "No valid Runbook found"
    }
}
} 


 
