#playground

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
### Cleanup no longer existing runbooks ### 

# Get Runbooks in Git
$Gitrunbooks = (Get-ChildItem -Path .\Runbooks\)
Write-output "Runbooks currently in GIT" 
Write-output $Gitrunbooks.BaseName

# Get Runbooks in account
$AutAccountRunbooks = (Get-AzAutomationRunbook -ResourceGroupName $rg -AutomationAccountName $aa)
Write-output "Runbook currently in Automation Account"
Write-output $AutAccountRunbooks.name 

$rg= "RG-AutomationCICD"
$aa = "aut-account-cicd-dev"


# compare the git runbooks with the AutAccount Runbooks
$runbookstobedeleted = (Compare-Object -ReferenceObject $Gitrunbooks.BaseName -DifferenceObject $AutAccountRunbooks.name)
$runbookstobedeletedasname = $runbookstobedeleted.InputObject # transform variable so that it´s availabe as a string 

foreach ($runbook in $runbookstobedeletedasname)
{
    Remove-AzAutomationRunbook -name $runbook -resourcegroupname $rg -automationaccountname $aa -force
}



