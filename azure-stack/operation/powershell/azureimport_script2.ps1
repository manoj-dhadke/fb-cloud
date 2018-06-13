# Install and import the API Version Profile required by Azure Stack into the
# current  PowerShell session.
#Set-ExecutionPolicy RemoteSigned
Try
{
$subscriptionname=$args[0]
$tenantusername=$args[1]
$tenantpassword=$args[2]
$tenantname=$args[3]

Use-AzureRmProfile `
  -Profile 2017-03-09-profile -Force >$null 2>&1

Install-Module `
  -Name AzureStack `
  -RequiredVersion 1.2.11
.\azureimport_script3.ps1 $subscriptionname $tenantusername $tenantpassword $tenantname
}
Catch [System.Exception]
{
Exit 1
}