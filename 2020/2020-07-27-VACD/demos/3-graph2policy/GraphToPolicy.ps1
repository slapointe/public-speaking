<#
.SYNOPSIS
Converts an Azure Resource Graph query into a policy rule.

.PARAMETER Query
Azure Resource Graph Query which needs to be converted to the policy rule

.PARAMETER Effect
Optional parameter for setting the policy effect. Default value is "audit"

.PARAMETER CreatePolicy
Optional parameter to create the policy and use the value as the policy name.

.EXAMPLE
./GraphToPolicy -Query "where type =~ 'microsoft.compute/virtualmachines' and isempty(aliases['Microsoft.Compute/virtualMachines/storageProfile.osDisk.managedDisk.id'])|summarize count()" -Effect "audit" -CreatePolicy "AuditNonManagedDiskPolicy"
#>
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True)]
	[string]$Query,
	[Parameter(Mandatory=$False)]
	[string]$Effect = "audit",
	[Parameter(Mandatory=$False)]
    [string]$CreatePolicy = "",
	[Parameter(Mandatory=$False)]
    [string]$ManagementGroupName = ""
)

function CreateNewPolicy
{
    param(
        [string]
        $ManagementGroupName
    )
	Write-Output "Creating policy '$CreatePolicy' ..."
    $policyRule = $resp -join '' -replace ' ', ''
    $policyRule = $policyRule[14..($policyRule.Length-2)] -join ''
    #$policyRule = [regex]::Unescape($policyRule)
    $params = @{
        Name = $CreatePolicy
        DisplayName = $CreatePolicy
        Policy = $policyRule
    }

    if($ManagementGroupName) {
        $params['ManagementGroupName'] = $ManagementGroupName
    }

    Write-verbose "PolicyRule: $PolicyRule" -Verbose
    az policy definition create --rules $policyRule --name $CreatePolicy --display-name $CreatePolicy
}

function CallAzureResourceGraph
{
    Write-Verbose "Query:$Query" -Verbose
	$response = & az rest --method post --uri '/providers/Microsoft.ResourceGraph/resources/policy?api-version=2019-04-01' --headers 'content-type=application/json' --uri-parameters "effect=$effect" --body ""$Query""
    if($response[0] -eq "{") {
        return $response
    }
	return $response[1..$response.Length]
}

$resp = CallAzureResourceGraph

if($CreatePolicy -ne ""){
    CreateNewPolicy -ManagementGroupName $ManagementGroupName
} else {
    Write-Output $resp
}