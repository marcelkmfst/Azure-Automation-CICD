#Script to be executed as part of the pipeline run


# parameters set via Pipeline
#$rg= (the resource group)
#$aa= (the automation account)
param ($aa, $published, $rg)

#variable set in Runbook
#$published (if true, pipeline will publisht the runbooks)
$published = 'true'



$runbooks=(Get-ChildItem -Path .\Runbooks\)
$runbooknamestring=$runbooks.name
ForEach  ($runbook in $runbooknamestring)
{
if ($published -eq 'true') {  ### if $published variable is set to true, the Import Cmdlet will be executed with "-published" option, else without 
        if ($runbook -like 'workflow*') 
        {
            Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type PowerShellWorkflow -Published -Force
        }
        elseif ($runbook -like '*.graphrunbook') 
        {
            Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type GraphicalPowerShell -Published -Force
        }
        elseif ($runbook -like '*.py') 
        {
            Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type Python2 -Published -Force
        }
        elseif ($runbook -like '*.ps1') # Powershell worklfows also have ps1 filetypeextension, so we can´t use ps1 to identify type, the if condition checks if the filename starts with "workflow"
        {
            Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type PowerShell -Published -Force
        }
        else 
        {
            Write-Output "starting Runbook Import............."
        }
    }
else {
    if ($runbook -like 'workflow*') 
    {
        Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type PowerShellWorkflow  -Force
    } 
    elseif ($runbook -like '*.graphrunbook') 
    {
        Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type GraphicalPowerShell -Force
    }
    elseif ($runbook -like '*.py') 
    {
        Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type Python2 -Force
    }
    elseif ($runbook -like '*.ps1') 
        {
            Import-AzAutomationRunbook -Path .\Runbooks\$runbook -ResourceGroupName $rg -AutomationAccountName $aa -Type PowerShell -Force
        } 
    else 
    {
        Write-Output "starting Runbook Import............."
    }
}
} 
# cleanup no longer existing runbooks

# Get Runbooks in Git
$Gitrunbooks 

# Get Runbooks in account
$AutAccountRunbooks = Get-AzAutomationRunbook -ResourceGroupName $rg -

# compare-object 
# $allrunbooks = get-azautomationrunbook -resourcegroupname $rg -automationAccountName $aa



# basename $runbooks[0].basename  to get filename without fileextension


# todo, hole beide Arrays (rubook in account und in repo)
# vergleiche beide miteinander
# lösche runbooks in automatoin account wenn diese nicht mehr in git sind 