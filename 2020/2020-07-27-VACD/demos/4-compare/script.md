`az graph query -q "where type =~ 'Microsoft.Storage/storageAccounts' | project id, name, resourceGroup" --output table`

`az graph query -q "where type =~ 'Microsoft.Storage/storageAccounts' | where name == 'contosodevstorage0'" > before.json`

