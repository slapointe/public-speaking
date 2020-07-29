# Azure Governance - Resource Graph - Demo 1

## Step 1: Setup & Context
* Open the Azure portal shell (https://shell.azure.com)

* Go to resource graph blade by searching on top

* Explain that for the moment an extension need to be installed since it is not yet part of azure-cli

`az extension list`
`az extension add --name resource-graph`


## Step 2: Policy enforcement
We noticed that secure transfer to storage accounts is a new feature and we want all our storage accounts to comply

* Lookup for all storage accounts

`az graph query -q "where type =~ 'Microsoft.Storage/storageAccounts' | project id, name, resourceGroup" --output table`

`az graph query -q "where type =~ 'Microsoft.Storage/storageAccounts' | where name == 'ivqhk3usc4vjg'" > before.json`

* Go in the portal, browse to storage account 'ivqhk3usc4vjg'

* Go to configuration blade, and change *Secure transfer required* setting to *Enabled*

`az graph query -q "where type =~ 'Microsoft.Storage/storageAccounts' | where name == 'ivqhk3usc4vjg'" > after.json`

* Integrate the condition with a new query

`az graph query -q "where type =~ 'Microsoft.Storage/storageAccounts' | where aliases['Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly'] =~ 'false' | project resourceGroup, name" --output table`

# graph2policy

* download GitHub tool from http://aka.ms/graph2policy

* Output/convert our query to a policy magically using GraphToPolicy using the following statement:

`.\GraphToPolicy.ps1 -Query "where type =~ 'Microsoft.Storage/storageAccounts' | where aliases['Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly'] =~ 'false'" -Effect deny`

* Create a policy definition and save it in Azure from our query

`.\GraphToPolicy.ps1 -Query "where type =~ 'Microsoft.Storage/storageAccounts' | where aliases['Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly'] =~ 'false'" -Effect deny -CreatePolicy 'Deny storage account with unsecure transfer'`
