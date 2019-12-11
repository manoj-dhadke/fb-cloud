<#########################################################################
#
#  INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
#  __________________
# 
#  (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
#  All Rights Reserved.
#  Product / Project: Flint IT Automation Platform
#  NOTICE:  All information contained herein is, and remains
#  the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
#  The intellectual and technical concepts contained
#  herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
#  Dissemination of this information or any form of reproduction of this material
#  is strictly forbidden unless prior written permission is obtained
#  from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
#>


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