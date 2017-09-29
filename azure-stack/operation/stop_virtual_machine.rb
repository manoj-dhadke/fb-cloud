require 'json'
require 'rubygems'
#begin
@log.trace("Started executing 'fb-cloud:azure-stack:operation:stop_virtual_machine.rb' flintbit...")
begin
    #Flintbit Input Parameters
    #Mandatory  
    @connector_name= @input.get("connector_name")                             #Name of the Connector
    @target= @input.get("target")               			                  #Target address
    @username = @input.get("username")               			              #Username
    @password = @input.get("password")               			              #Password
    @shell = "ps"                 			                                  #Shell Type
    @transport = @input.get("transport")               			              #Transport
    @operation_timeout = 400                                            		  #Operation Timeout
    @no_ssl_peer_verification = @input.get("no_ssl_peer_verification")        #SSL Peer Verification
    @port = @input.get("port")                                                #Port Number
    @request_timeout=400000                                   #Timeout
    @aadtenant_name= @input.get("azure-ad-tenant-name")                   #tenant-name for the tenant
    @tenant_username = @input.get("tenant-username")                   #tenant-username of the tenant
    @tenant_password= @input.get("tenant-password")                   #tenant-password for the tenant user
    @resource_group_name= @input.get("resource-group-name")                   #resource group name
    @virtual_machine_name= @input.get("vm-name")                   #virtual machine name to perform operation 
    @subscription_name= @input.get("subscription-name")                   #subscription name 

    @log.info("Flintbit input parameters are,  connector name        ::    #{@connector_name} |
                                            target                   ::    #{@target} |
                                            username                 ::    #{@username}|
                                            shell                    ::    #{@shell}|
                                            transport                ::    #{@transport}|
                                            operation_timeout        ::    #{@operation_timeout}|
                                            no_ssl_peer_verification ::    #{@no_ssl_peer_verification}|
			  		    AAD_tenant_name	     ::    #{@aadtenant_name}|
                                            Tenant_username          ::    #{@tenant_username}|
                                            Subscription_name        ::    #{@subscription_name}|
					    Resource_group_name	     ::    #{@resource_group_name}|
                                            Vm_name	             ::    #{@virtual_machine_name}| 
                                            port                     ::    #{@port}")
    #building command to import dependency for azure stack
    import_command="cd C:\\AzureStack-Tools-master; .\\azureimport_script1.ps1"
    #calling winrm connector to execute command 
    import_dependency = @call.connector(@connector_name)
                    	     .set("target",@target)
	                     .set("username",@username)
         	             .set("password",@password)
                  	     .set("transport",@transport)
	                     .set("command",import_command)
	                     .set("port",@port)
	                     .set("shell",@shell)
         	             .set("operation_timeout",@operation_timeout)
	                     .set("timeout",@request_timeout)
			     .timeout(@request_timeout)
	                     .sync                
  

    #Winrm Connector Response Meta Parameters
    import_exitcode=import_dependency.exitcode           #Exit status code
    import_message=import_dependency.message            #Execution status message
   
    if import_exitcode == 0       
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{import_exitcode} | 
                                                            message ::  #{import_message}") 
	     login_command="cd C:\\AzureStack-Tools-master; .\\azureimport_script2.ps1 #{@subscription_name} #{@tenant_username} #{@tenant_password} #{@aadtenant_name};.\\stopazurestackvm.ps1 #{@virtual_machine_name} #{@resource_group_name}  2>&1|convertto-json"
	     login_azure_stack= @call.connector(@connector_name)
                    	             .set("target",@target)
	                    	     .set("username",@username)
         	                     .set("password",@password)
                  	             .set("transport",@transport)
	                   	     .set("command",login_command)
	                     	     .set("port",@port)
	                     	     .set("shell",@shell)
         	             	     .set("operation_timeout",@operation_timeout)
	                             .set("timeout",@request_timeout)
			             .timeout(@request_timeout)
	                   	     .sync    
                 
		result=login_azure_stack.get('result')
                result=@util.json(result)
                exception=result.get('Exception')

		if exception.nil?
			 @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{login_azure_stack.exitcode} | 
                                                            message ::  #{login_azure_stack.message}")	
			 @output.set('exit-code', 0).set('message', login_azure_stack.message)	    

	        else
			exception=@util.json(exception)
                        message=exception.get('Message')
			@log.error("ERROR in executing #{@connector_name} where, exitcode :: -1 | 
                                                            message ::  #{message}")
       			@output.set('exit-code', 1).set('message',message)
 
	       end


    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{import_exitcode} | 
                                                            message ::  #{import_message}")
        @output.set('exit-code', 1).set('message', import_message)

    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure-stack:operation:stop_virtual_machine.rb' flintbit...")
#end
