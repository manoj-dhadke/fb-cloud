Set-ExecutionPolicy RemoteSigned -force
Try
{
#Get public ip of the virtual machine
$networkInterfaceName=$args[0]
$resourcegroupname=$args[1]
Get-AzureRmNetworkInterface -Name $networkInterfaceName -ResourceGroupName $resourcegroupname
}
Catch [System.Exception]
{
Exit 1
}