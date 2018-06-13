Set-ExecutionPolicy RemoteSigned -force
Try
{
#Get power state of the virtual machine
$resourcegroupname=$args[0]
$vmname=$args[1]
Get-AzureRmVM -ResourceGroupName $resourcegroupname -Name $vmname -Status
}
Catch [System.Exception]
{
Exit 1
}