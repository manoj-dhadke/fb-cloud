log.trace("Started executing 'fb-cloud:azure-stack:operation:create_virtual_machines.groovy' flintbit...")
try{
    connector_name= input.get("connector_name")                      //Name of the Connector
    target= input.get("target")               			                  //Target address
    username = input.get("username")               			            //Username
    password = input.get("password")               			            //Password
    shell = "ps"                 			                              //Shell Type
    transport = input.get("transport")               			          //Transport
    operation_timeout = 1000                                         //Operation Timeout
    no_ssl_peer_verification = input.get("no_ssl_peer_verification")    //SSL Peer Verification
    port = input.get("port")                                            //Port Number
    request_timeout=1000000                                              //Timeout
    aadtenant_name= input.get("azure-ad-tenant-name")                   //tenant-name for the tenant
    tenant_username = input.get("tenant-username")                   //tenant-username of the tenant
    tenant_password= input.get("tenant-password")                   //tenant-password for the tenant user
    subscription_name= input.get("subscription-name")                //subscription name
    resourcegroup=input.get("resourcegroup")
    storagename=input.get("storagename")
    subnetname=input.get("subnetname")
    vnetname=input.get("vnetname")
    networksecuritygroup=input.get("networksecuritygroup")
    nicname=input.get("nicname")
    vmusername=input.get("vmusername")
    vmpassword=input.get("vmpassword")
    vmname=input.get("vmname")
    vmsize=input.get("vmsize")
    publishername=input.get("publishername")
    offer=input.get("offer")
    skus=input.get("skus")
    short_description = "Provision a Azure Stack Virtual Machine"
    impact = "1"
    urgency = "2"
    connector_name_servicenow=input.get("connector_name_servicenow")
    description = ("Please provision a Azure Stack Virtual Machine with the mentioned configuration details- Virtual Machine Name: ${vmname} || Resource Group : ${resourcegroup} || Virtual Machine size : ${vmsize} || Operating System: ${offer}")
    data = [:]
    data = ["short_description": short_description, "description":description, "impact" :impact, "urgency" : urgency, "caller_id":"abraham.lincoln"]
    servicenow_incident = call.bit("flint-util:snow:incident:create.rb")
                              .set("connector_name" ,connector_name_servicenow)
                              .set("data",data)
                              .sync()
    result = servicenow_incident.get("result")
    result = util.json(result)
    sys_id= result.get("result.sys_id")
    log.info("Sys-id:: ${sys_id}")
    incident_number = result.get("result.number")
    log.info("serviceNow Response:: ${servicenow_incident}")
    response_exitcode = servicenow_incident.get("response_exitcode")
if (servicenow_incident!= null && response_exitcode == 0){
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
      data_to_resolve_ticket = [:]
      data_to_resolve_ticket = ["close_code": "Solved (Permanently)", "close_notes" : "The incident ticket is resolved successfully and the Virtual Machine got provisioned with name: ${vmname}", "state": "Resolved"]
      //log.info("${data_to_resolve_ticket.to_json}")

      update_incident_response = call.bit("flint-util:snow:incident:update.rb")
                                     .set("connector_name" ,connector_name_servicenow)
                                     .set('sys-id', sys_id)
                                     .set("data",data_to_resolve_ticket)
                                     .sync()
      log.info("update_incident_response: ${update_incident_response}")
      user_message= "Successfully created AzureStack VM with name ${vmname} in resource group ${resourcegroup}||Azure Stack Virtual Machine provisioning successful.ServiceNow ticket: ${incident_number} is resolved"
      output.set('exit-code', 0).set('message', login_azure_stack.message).set("user_message",user_message)
}
else {
user_message= "Failed to create AzureStack VM with name ${vmname} in resource group ${resourcegroup} || Update incident failed on incident number ${incident_number}"
log.info("Update incident failed on incident number ${incident_number}")
log.error("ERROR in executing ${connector_name} where, exitcode :: ${import_exitcode} |message ::  ${import_message}")
output.set('exit-code', 1).set('message', import_message).set("user_message",user_message)
}
}
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('error', e.message)
}
log.trace("Finished executing 'fb-cloud:azure-stack:operation:create_virtual_machine.groovy' flintbit...")
