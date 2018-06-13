# Install the AzureRM.Bootstrapper module. Select Yes when prompted to install NuGet 
`Set-ExecutionPolicy RemoteSigned -force`
Try
{
Install-Module `
  -Name AzureRm.BootStrapper
}
Catch [System.Exception]
{
Exit 1
}