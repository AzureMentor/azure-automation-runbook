<#
    .DESCRIPTION 
    CleanUp-AzureResources.
    For Azure Automation Runbook.
#>

$connectionName = "AzureRunAsConnection"

try {
    # Get the connection "AzureRunAsConnection"
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Connect-AzAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection) {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

# Remove any expired Azure resources (i.e. resource with tags.expiryDate < today's date)
$expiredResources = Search-AzGraph -Query 'where todatetime(tags.expiryDate) < now() | project id'

foreach ($expiredResource in $expiredResources) {
	Remove-AzResource -ResourceId $expiredResource.Id -Force
}

# Remove any empty Resource Groups
$resGroups = Get-AzResourceGroup

foreach( $resGroup in $resGroups ) {
	$name = $resGroup.ResourceGroupName
	$count = (Get-AzResource | Where-Object{ $_.ResourceGroupName -match $name }).Count
	if($count -eq 0) {
		Remove-AzResourceGroup -Name $name -Force
	}
}