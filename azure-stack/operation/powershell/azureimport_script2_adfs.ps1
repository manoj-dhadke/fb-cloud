# Install and import the API Version Profile required by Azure Stack into the
# current  PowerShell session.
#Set-ExecutionPolicy RemoteSigned
Try
{
$subscriptionname=$args[0]
$tenantusername=$args[1]
$tenantpassword=$args[2]


Use-AzureRmProfile `
  -Profile 2017-03-09-profile -Force >$null 2>&1

Install-Module `
  -Name AzureStack `
  -RequiredVersion 1.2.11
.\azurestack_adfs.ps1 $subscriptionname $tenantusername $tenantpassword
}
Catch [System.Exception]
{
Exit 1
}