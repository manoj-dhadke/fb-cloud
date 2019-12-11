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
import groovy.json.JsonSlurper
log.trace("Started executing 'fb-cloud:azure-stack:operation:get_power_status_of_vm.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory  
    connector_name= input.get("connector_name")                             // Name of the Connector
    target= input.get("target")               			                  // Target address
    username = input.get("username")               			               // Username
    password = input.get("password")               			              // Password
    shell = "ps"                 			                                  // Shell Type
    transport = input.get("transport")               			              // Transport
    operation_timeout = 1000                                            		  // Operation Timeout
    no_ssl_peer_verification = input.get("no_ssl_peer_verification")        // SSL Peer Verification
    port = input.get("port")                                                // Port Number
    request_timeout=1000000                                                  // Timeout
    aadtenant_name= input.get("azure-ad-tenant-name")                   //tenant-name for the tenant
    tenant_username = input.get("tenant-username")                   //tenant-username of the tenant
    tenant_password= input.get("tenant-password")                   //tenant-password for the tenant user
    subscription_name= input.get("subscription-name")                   //subscription name
    resource_group_name= input.get("resource-group-name")                   //resource group name
    virtual_machine_name= input.get("vm-name")                   // virtual machine name to perform operation 
    
    log.info("Flintbit input parameters are,connector name :: ${connector_name} |target:: ${target} |username:: ${username}|shell:: ${shell}|transport:: ${transport}|operation_timeout:: ${operation_timeout}|no_ssl_peer_verification :: ${no_ssl_peer_verification}|AAD_tenant_name:: ${aadtenant_name}|Tenant_username:: ${tenant_username}|Subscription_name:: ${subscription_name}| port:: ${port} | resource group name: ${resource_group_name}| VM Name: ${virtual_machine_name}")
    // building command to import dependency for azure stack
    import_command="cd C:\\AzureStack-Tools-master; .\\azureimport_script1.ps1"
    //calling winrm connector to execute command 
    import_dependency = call.connector(connector_name)
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
  

    //Winrm Connector Response Meta Parameters
    import_exitcode=import_dependency.exitcode()            //Exit status code
    import_message=import_dependency.message()              //Execution status message
   
    if (import_exitcode == 0){
         log.info("SUCCESS in executing ${connector_name} where, exitcode :: ${import_exitcode} | message ::  ${import_message}") 
	     login_command="cd C:\\AzureStack-Tools-master; .\\azureimport_script2.ps1 ${subscription_name} ${tenant_username} ${tenant_password} ${aadtenant_name};.\\get_power_state.ps1 ${resource_group_name} ${virtual_machine_name} 2>&1|convertto-json"
	     login_azure_stack= call.connector(connector_name)
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
                 
                result=login_azure_stack.get('result')
                result=util.json(result)
                log.info("Result:: ${result}")
                exception=result.get('Exception')
                login_azure_stack_exitcode = login_azure_stack.exitcode()

		if (login_azure_stack_exitcode == 0){
             log.info("SUCCESS in executing ${connector_name} where, exitcode :: ${login_azure_stack.exitcode()} |message ::  ${login_azure_stack.message()}")	
			 output.set('exit-code', 0).set('message', login_azure_stack.message()).set('power-status',result.toString())
            
        }
	  else{
            exception=util.json(exception)
            message=exception.get('Message')
			log.error("ERROR in executing ${connector_name} where, exitcode :: -1 |message ::  ${message}")
       		output.set('exit-code', 1).set('message',message)

      }

    }      
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${import_exitcode} |message :: ${import_message}")
        output.set('exit-code', 1).set('message', import_message)

    }
    }
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('error', e.message)
}         
log.trace("Finished executing 'fb-cloud:azure-stack:operation:get_power_status_of_vm.groovy' flintbit...")