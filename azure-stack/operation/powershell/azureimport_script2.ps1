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

# Install and import the API Version Profile required by Azure Stack into the
# current  PowerShell session.
#Set-ExecutionPolicy RemoteSigned
Try
{
$subscriptionname=$args[0]
$tenantusername=$args[1]
$tenantpassword=$args[2]
$tenantname=$args[3]

Use-AzureRmProfile `
  -Profile 2017-03-09-profile -Force >$null 2>&1

Install-Module `
  -Name AzureStack `
  -RequiredVersion 1.2.11
.\azureimport_script3.ps1 $subscriptionname $tenantusername $tenantpassword $tenantname
}
Catch [System.Exception]
{
Exit 1
}