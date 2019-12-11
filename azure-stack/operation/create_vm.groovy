/*************************************************************************
 * 
 * INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
 * __________________
 * 
 * (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
 * All Rights Reserved.
 * Product / Project: Flint IT Automation Platform
 * NOTICE:  All information contained herein is, and remains
 * the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
 * The intellectual and technical concepts contained
 * herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
 * Dissemination of this information or any form of reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
 */
log.trace("Started executing 'fb-cloud:azure-stack:operation:create_virtual_machines.groovy' flintbit...")
try{
    azure_stack_config = input.get('azure_stack_config')
    connector_name= azure_stack_config.get("connector_name")                            //Name of the Connector
    target= azure_stack_config.get("target")               			                    //Target address
    username = azure_stack_config.get("username")               			            //Username
    password = azure_stack_config.get("password")               			            //Password
    transport = azure_stack_config.get("transport")               			            //Transport
    no_ssl_peer_verification = azure_stack_config.get("no_ssl_peer_verification")       //SSL Peer Verification
    port = azure_stack_config.get("port")                                               //Port Number
    aadtenant_name= azure_stack_config.get("azure-ad-tenant-name")                      //tenant-name for the tenant
    tenant_username = azure_stack_config.get("tenant-username")                         //tenant-username of the tenant
    tenant_password= azure_stack_config.get("tenant-password")                          //tenant-password for the tenant user
    subscription_name= azure_stack_config.get("subscription-name") 


    request_timeout=1000000                                                             //Timeout
    operation_timeout = 1000                                                            //Operation Timeout
    shell = "ps"                 			                                            //Shell Type
    
    resourcegroup=input.get("resource_group")
    storagename=input.get("storage")
    subnetname=input.get("subnet")
    vnetname=input.get("vnet")
    networksecuritygroup=input.get("network_security_group")
    nicname=input.get("network_interface_card")
    vmusername=input.get("virtual_machine_username")
    vmpassword=input.get("virtual_machine_password")
    vmname=input.get("name")
    vmsize=input.get("virtual_machine_size")
    publishername=input.get("publisher_name")
    offer=input.get("operating_system")
    skus=input.get("skus")
log.info("Flintbit input parameters are,connector name:: ${connector_name} |target:: ${target} |username:: ${username}|shell:: ${shell}|transport:: ${transport}|operation_timeout:: ${operation_timeout}|no_ssl_peer_verification :: ${no_ssl_peer_verification}|AAD_tenant_name:: ${aadtenant_name}|Tenant_username:: ${tenant_username}|Subscription_name:: ${subscription_name}|port :: ${port}")
import_command="cd C:\\AzureStack-Tools-master; .\\azureimport_script1.ps1"
import_dependency =  call.connector(connector_name)
                         .set("target",target)
                         .set("username",username)
                         .set("password",password)
                         .set("transport",transport)
                         .set("command",import_command)
                         .set("port",port)
                         .set("shell",shell)
                         .set("operation_timeout",operation_timeout)
                         .set("timeout",request_timeout)
                         .timeout(request_timeout)
                         .sync()

import_exitcode=import_dependency.exitcode()           //Exit status code
import_message=import_dependency.message()          //Execution status message

if (import_exitcode == 0){
log.info("SUCCESS in executing ${connector_name} where, exitcode :: ${import_exitcode} |message ::  ${import_message}")
  if (offer == "WindowsServer"){
  login_command="cd C:\\AzureStack-Tools-master; .\\azureimport_script2.ps1 ${subscription_name} ${tenant_username} ${tenant_password} ${aadtenant_name};.\\create_windows_vm.ps1 ${resourcegroup} ${storagename} ${subnetname} ${vnetname} ${networksecuritygroup} ${nicname} ${vmusername} ${vmpassword} ${vmname} ${vmsize} ${publishername} ${offer} ${skus} 2>&1 |convertto-json"
  login_azure_stack=  call.connector(connector_name)
                                 .set("target",target)
                                 .set("username",username)
                                 .set("password",password)
                                 .set("transport",transport)
                                 .set("command",login_command)
                                 .set("port",port)
                                 .set("shell",shell)
                                 .set("operation_timeout",operation_timeout)
                                 .set("timeout",request_timeout)
                                 .timeout(request_timeout)
                                 .sync()
  }
  else if (offer == "UbuntuServer"){
  login_command="cd C:\\AzureStack-Tools-master; .\\azureimport_script2.ps1 ${subscription_name} ${tenant_username} ${tenant_password} ${aadtenant_name};.\\create_linux_vm.ps1 ${resourcegroup} ${storagename} ${subnetname} ${vnetname} ${networksecuritygroup} ${nicname} ${vmusername} ${vmpassword} ${vmname} ${vmsize} ${publishername} ${offer} ${skus} 2>&1 |convertto-json"
  login_azure_stack=  call.connector(connector_name)
                                 .set("target",target)
                                 .set("username",username)
                                 .set("password",password)
                                 .set("transport",transport)
                                 .set("command",login_command)
                                 .set("port",port)
                                 .set("shell",shell)
                                 .set("operation_timeout",operation_timeout)
                                 .set("timeout",request_timeout)
                                 .timeout(request_timeout)
                                 .sync()

  }
  else{
    log.info("Unable to get the offer in Azurestack... Azurestack VM creation failed")
    }
      result=login_azure_stack.get('result')
      log.info("Result::${result}")
		  //result=util.json(result)
		  //exception=result.get('Exception')
			log.info("SUCCESS in executing ${connector_name} where, exitcode :: ${login_azure_stack.exitcode} |message ::  ${login_azure_stack.message}")
      user_message= "Successfully created AzureStack VM with name ${vmname} in resource group ${resourcegroup}"
      output.set('exit-code', 0).set('message', login_azure_stack.message).set("user_message",user_message)
}
else {
user_message= "Failed to create AzureStack VM with name ${vmname} in resource group ${resourcegroup}"
log.error("ERROR in executing ${connector_name} where, exitcode :: ${import_exitcode} |message ::  ${import_message}")
output.set('exit-code', 1).set('message', import_message).set("user_message",user_message)
}
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('error', e.message)
}
log.trace("Finished executing 'fb-cloud:azure-stack:operation:create_virtual_machine.groovy' flintbit...")