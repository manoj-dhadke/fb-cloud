#Get details of the virtual machine
Set-ExecutionPolicy RemoteSigned -force
Try
{
$vmname=$args[0]
$resourcegroupname=$args[1]
Get-AzureRmVM -ResourceGroupName $resourcegroupname -Name $vmname 
}
Catch [System.Exception]
{
#$ErrorMessage = $_.Exception.Message
#echo $ErrorMessage
Exit 1
}