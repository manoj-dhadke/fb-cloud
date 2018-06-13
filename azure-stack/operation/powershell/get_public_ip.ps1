Set-ExecutionPolicy RemoteSigned -force
Try
{
#Get public ip of the virtual machine
$publicIpName=$args[0]
$resourcegroupname=$args[1]
Get-AzureRmPublicIpAddress -Name $publicIpName -ResourceGroupName $resourcegroupname
}
Catch [System.Exception]
{
Exit 1
}