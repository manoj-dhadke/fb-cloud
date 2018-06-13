Set-ExecutionPolicy RemoteSigned -force
Try
{
$vmname=$args[0]
$resourcegroupname=$args[1]
Start-AzureRmVM -ResourceGroupName $resourcegroupname -Name $vmname
}
Catch [System.Exception]
{
Exit 1
}