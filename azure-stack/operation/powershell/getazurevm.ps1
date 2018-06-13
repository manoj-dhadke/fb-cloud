#Get list of available VM's with details
Set-ExecutionPolicy RemoteSigned -force
Try
{
Get-AzureRmVM 
}
Catch [System.Exception]
{
Exit 1
}