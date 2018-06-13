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


