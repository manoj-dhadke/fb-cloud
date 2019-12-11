<#########################################################################
#
#  INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
#  __________________
# 
#  (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
#  All Rights Reserved.
#  Product / Project: Flint IT Automation Platform
#  NOTICE:  All information contained herein is, and remains
#  the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
#  The intellectual and technical concepts contained
#  herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
#  Dissemination of this information or any form of reproduction of this material
#  is strictly forbidden unless prior written permission is obtained
#  from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
#>


# Navigate to the downloaded folder and import the **Connect** PowerShell module
$subscriptionname=$args[0]
$tenantusername=$args[1]
$tenantpassword=$args[2]

Set-ExecutionPolicy RemoteSigned
Import-Module .\Connect\AzureStack.Connect.psm1
Try
{
# For Azure Stack development kit, this value is set to https://management.local.azurestack.external. To get this value for Azure Stack integrated systems, contact your service provider.
$ArmEndpoint = "https://management.local.azurestack.external"

# For Azure Stack development kit, this value is set to https://graph.local.azurestack.external/. To get this value for Azure Stack integrated systems, contact your service provider.
$GraphAudience = "https://adfs.local.azurestack.external/"

# Register an AzureRM environment that targets your Azure Stack instance
Add-AzureRMEnvironment `
  -Name "AzureStackUser" `
  -ArmEndpoint $ArmEndpoint

# Set the GraphEndpointResourceId value
Set-AzureRmEnvironment `
  -Name "AzureStackUser" `
  -GraphAudience $GraphAudience `
  -EnableAdfsAuthentication:$true

# Get the Active Directory tenantId that is used to deploy Azure Stack
$TenantID = Get-AzsDirectoryTenantId `
  -ADFS `
  -EnvironmentName "AzureStackUser"

# Sign in to your environment
$password = $tenantpassword | ConvertTo-SecureString -asPlainText -Force
$username = $tenantusername
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Login-AzureRmAccount `
  -EnvironmentName "AzureStackUser" `
  -TenantId $TenantID `
  -Credential $credential >$null 2>&1 
Select-AzureRmSubscription -SubscriptionName $subscriptionname >$null 2>&1
}
Catch [System.Exception]
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage
Exit 1
}