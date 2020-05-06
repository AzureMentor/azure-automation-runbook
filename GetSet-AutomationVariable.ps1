<# 
    .DESCRIPTION 
    Get/Set Automation Variable examples.
    For Azure Automation Runbook.
#> 

# Get value of ExistingVariable
$result = Get-AutomationVariable -Name 'ExistingVariable'
Write-Output $result

# Change value of ExistingVariable using Set-AutomationVariable
Set-AutomationVariable -Name 'ExistingVariable' -Value "new value"

# ERROR: Get-AutomationVariable : Variables asset not found. To create this Variables asset, navigate to the Assets blade and create a Variables asset named: UnknownVariable.
$result = Get-AutomationVariable -Name 'UnknownVariable'
Write-Output $result
