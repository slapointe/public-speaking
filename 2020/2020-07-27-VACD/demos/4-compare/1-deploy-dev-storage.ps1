$ErrorActionPreference = 'Stop'

$resourceGroup = New-AzResourceGroup -Name 'vacd-demo-storageaccounts' -Location 'eastus' -Tag @{department='demo'; costCenter='demo'; environment='demo'; owner='demo@domain.com'} -Force

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup.ResourceGroupName `
    -TemplateFile $PSScriptRoot\contoso-dev-storage.json `
    -numberOfInstances 10 `
    -supportsHttpsTrafficOnly $false `
    -Verbose
