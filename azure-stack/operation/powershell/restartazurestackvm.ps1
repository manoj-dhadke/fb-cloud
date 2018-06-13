Set-ExecutionPolicy RemoteSigned -force
Try
{
$vmname=$args[0]
$resourcegroupname=$args[1]
Restart-AzureRmVM -ResourceGroupName $resourcegroupname -Name $vmname
}
Catch [System.Exception]
{
Exit 1
}