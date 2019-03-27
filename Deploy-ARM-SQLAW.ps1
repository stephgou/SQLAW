Param(  
    # Name of the subscription to use for azure cmdlets
    [string] $subscriptionName = "StephgouInTheCloud",
    [string] $subscriptionId = "0459dbd5-b73e-4a5b-b052-250dc51ac622",
    #Paramètres du Azure Ressource Group
    $prefix = "CEGID-SQLAW",
    $resourceGroupName = "SG-RG-" + $prefix.ToUpper(),
    $resourceLocation = "West Europe",
	$resourceGroupDeploymentName = "$prefix-Deployed",
    $templateFile = "azuredeploy.json",
    $templateParameterFile = "azuredeploy.parameters.json",
    $templateFolder = ".",
    $tagName = "$prefix_RG",
    $tagValue = "$prefix"
    )

#region init
Set-PSDebug -Strict

cls
$d = get-date
Write-Host "Starting Deployment $d"

$scriptFolder = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Host "scriptFolder" $scriptFolder

set-location $scriptFolder
#endregion init

#Login-AzureRmAccount -SubscriptionId $subscriptionId
#Get-AzureRmResourceGroup -Name $resourceGroupName -ev notPresent -ea 0

# Resource group create
New-AzureRmResourceGroup `
	-Name $resourceGroupName `
	-Location $resourceLocation `
    -Tag @{Name=$tagName;Value=$tagValue} `
    -Verbose

# Resource group deploy
New-AzureRmResourceGroupDeployment `
    -Name $resourceGroupDeploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile "$scriptFolder\$templatefolder\$templateFile" `
	-TemplateParameterFile "$scriptFolder\$templatefolder\$templateParameterFile" `
    -Debug -Verbose -DeploymentDebugLogLevel All

$d = get-date
Write-Host "Stopping Deployment $d"