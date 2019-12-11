=begin
##########################################################################
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
=end

require 'json'
require 'rubygems'
#begin
@log.trace("Started executing 'fb-cloud:azure-stack:operation:create_virtual_machines.rb' flintbit...")
begin
	#Flintbit Input Parameters
	#Mandatory
	@connector_name= @input.get("connector_name")                             #Name of the Connector
	@target= @input.get("target")               			                        #Target address
	@username = @input.get("username")               			                    #Username
	@password = @input.get("password")               			                    #Password
	@shell = "ps"                 			                                      #Shell Type
	@transport = @input.get("transport")               			                  #Transport
	@operation_timeout = 1000                                         		  #Operation Timeout
	@no_ssl_peer_verification = @input.get("no_ssl_peer_verification")        #SSL Peer Verification
	@port = @input.get("port")                                                #Port Number
	@request_timeout=1000000                                                  #Timeout
	@aadtenant_name= @input.get("azure-ad-tenant-name")                       #tenant-name for the tenant
	@tenant_username = @input.get("tenant-username")                          #tenant-username of the tenant
	@tenant_password= @input.get("tenant-password")                           #tenant-password for the tenant user
	@subscription_name= @input.get("subscription-name")                       #subscription name
        @resourcegroup=@input.get("resourcegroup")
	@storagename=@input.get("storagename")
	@subnetname=@input.get("subnetname")
	@vnetname=@input.get("vnetname")
	@networksecuritygroup=@input.get("networksecuritygroup")
        @nicname=@input.get("nicname")
        @vmusername=@input.get("vmusername")
        @vmpassword=@input.get("vmpassword")
        @vmname=@input.get("vmname")
        @vmsize=@input.get("vmsize")
        @publishername=@input.get("publishername")
        @offer=@input.get("offer")
        @skus=@input.get("skus")

  @log.info("Flintbit input parameters are,  connector name        ::      #{@connector_name} |
                                            target                   ::    #{@target} |
                                            username                 ::    #{@username}|
                                            shell                    ::    #{@shell}|
                                            transport                ::    #{@transport}|
                                            operation_timeout        ::    #{@operation_timeout}|
                                            no_ssl_peer_verification ::    #{@no_ssl_peer_verification}|
					                                  AAD_tenant_name	         ::    #{@aadtenant_name}|
                                            Tenant_username          ::    #{@tenant_username}|
                                            Subscription_name        ::    #{@subscription_name}|
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
    if (@offer == "WindowsServer")
		login_command="cd C:\\AzureStack-Tools-master; .\\azureimport_script2.ps1 #{@subscription_name} #{@tenant_username} #{@tenant_password} #{@aadtenant_name};.\\create_windows_vm.ps1 #{@resourcegroup} #{@storagename} #{@subnetname} #{@vnetname} #{@networksecuritygroup} #{@nicname} #{@vmusername} #{@vmpassword} #{@vmname} #{@vmsize} #{@publishername} #{@offer} #{@skus} 2>&1 |convertto-json"
		@login_azure_stack= @call.connector(@connector_name)
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
elsif (@offer == "UbuntuServer")
  login_command="cd C:\\AzureStack-Tools-master; .\\azureimport_script2.ps1 #{@subscription_name} #{@tenant_username} #{@tenant_password} #{@aadtenant_name};.\\create_linux_vm.ps1 #{@resourcegroup} #{@storagename} #{@subnetname} #{@vnetname} #{@networksecuritygroup} #{@nicname} #{@vmusername} #{@vmpassword} #{@vmname} #{@vmsize} #{@publishername} #{@offer} #{@skus} 2>&1 |convertto-json"
  @login_azure_stack= @call.connector(@connector_name)
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
  else
    @log.info("Unable to get the offer in Azurestack... Azurestack VM creation failed")
  end
		result=@login_azure_stack.get('result')
    @log.info("Result:: #{result}")
		#result=@util.json(result)
		#exception=result.get('Exception')

			@log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{@login_azure_stack.exitcode} |message ::  #{@login_azure_stack.message}")
      @user_message= "Successfully created AzureStack VM with name #{@vmname} in resource group #{@resourcegroup}"
      @output.set('exit-code', 0).set('message', @login_azure_stack.message).set("user_message",@user_message)

	else
                @user_message= "Failed to create AzureStack VM with name #{@vmname} in resource group #{@resourcegroup}"
		@log.error("ERROR in executing #{@connector_name} where, exitcode :: #{import_exitcode} |message ::  #{import_message}")
		@output.set('exit-code', 1).set('message', import_message).set("user_message",@user_message)

	end
rescue Exception => e
	@log.error(e.message)
	@output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure-stack:operation:create_virtual_machine.rb' flintbit...")
#end
