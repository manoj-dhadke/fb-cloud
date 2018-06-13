Set-ExecutionPolicy RemoteSigned -force
Try
{
$vmname=$args[0]
$resourcegroupname=$args[1]
Stop-AzureRmVM -ResourceGroupName $resourcegroupname -Name $vmname -Force
}
Catch [System.Exception]
{
Exit 1
}