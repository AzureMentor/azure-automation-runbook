<# 
    .DESCRIPTION 
    Test SQL Connection.  For Azure Automation Runbook.
#> 

function Test-SQLConnectionString{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        $ConnectionString
    )
    try
    {
        $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString;
        $sqlConnection.Open();
        $sqlConnection.Close();

        return $true;
    }
    catch
    {
        return $false;
    }
}

# Get value of ExistingVariable
$result = Get-AutomationVariable -Name 'ExistingVariable'
Write-Output $result

# Change value of ExistingVariable using Set-AutomationVariable
Set-AutomationVariable -Name 'ExistingVariable' -Value "new value"

# ERROR: Get-AutomationVariable : Variables asset not found. To create this Variables asset, navigate to the Assets blade and create a Variables asset named: UnknownVariable.
$result = Get-AutomationVariable -Name 'UnknownVariable'
Write-Output $result
