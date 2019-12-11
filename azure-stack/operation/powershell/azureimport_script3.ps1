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


Set-ExecutionPolicy RemoteSigned -force
$subscriptionname=$args[0]
$tenantusername=$args[1]
$tenantpassword=$args[2]
$tenantname=$args[3]
# import the Connect and ComputeAdmin modules   
Import-Module .\Connect\AzureStack.Connect.psm1
#Import-Module .\ComputeAdmin\AzureStack.ComputeAdmin.psm1
# Create the Azure Stack operator's AzureRM environment by using the following cmdlet:
Try
{
 Add-AzureRMEnvironment `
  -Name "AzureStack" `
  -ArmEndpoint "https://management.local.azurestack.external" >$null 2>&1

Set-AzureRmEnvironment `
 -Name "AzureStack" `
 -GraphAudience "https://graph.windows.net/" >$null 2>&1 

$TenantID = Get-AzsDirectoryTenantId `
  -AADTenantName $tenantname `
  -EnvironmentName AzureStack

#  echo "$TenantID"

$password = $tenantpassword | ConvertTo-SecureString -asPlainText -Force
$username = $tenantusername
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Login-AzureRmAccount `
  -EnvironmentName "AzureStack" `
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


