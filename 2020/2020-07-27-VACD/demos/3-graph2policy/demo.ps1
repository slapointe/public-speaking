& .\GraphToPolicy.ps1 -Query "where isempty(tags['environment'])" -effect "deny"

& .\GraphToPolicy.ps1 -Query "where type =~ 'Microsoft.Compute/virtualMachines' | where properties.availabilitySet.id == '' | project subscriptionId, resourceGroup, name" -effect "audit"

& .\GraphToPolicy.ps1 -Query "where type =~ 'microsoft.compute/virtualmachines' and isempty(aliases['Microsoft.Compute/virtualMachines/storageProfile.osDisk.managedDisk.id'])|summarize count()" -effect "audit"