require 'json'
require 'rubygems'
#begin
@log.trace("Started executing 'fb-cloud:hyperv:operation:details_virtual_machine_hyperv.rb' flintbit...")
begin
    #Flintbit Input Parameters
    #Mandatory  
    @connector_name= @input.get("connector_name")                             #Name of the Connector
    @action="vm-details"
    @vm_id= @input.get("vm-id")      
    @target= @input.get("target")               			                  #Target address
    @username = @input.get("username")               			              #Username
    @password = @input.get("password")               			              #Password
    @shell = "ps"               			                                  #Shell Type
    @transport = @input.get("transport")               			              #Transport
    @type = @input.get("type")                          #Command to run
    @operation_timeout = 80               		                              #Operation Timeout
    @no_ssl_peer_verification = @input.get("no_ssl_peer_verification")        #SSL Peer Verification
    @port = @input.get("port")                                                #Port Number
    @request_timeout= "300000"                     #Timeout
					  
    @log.info("Flintbit input parameters are,  connector name        ::    #{@connector_name} |
					    action		     ::    #{@action}|
					    vm-id		     ::    #{@vm_id}|
                                            target                   ::    #{@target} |
                                            username                 ::    #{@username}|
                                            password                 ::    #{@password} |
                                            shell                    ::    #{@shell}|
                                            transport                ::    #{@transport}|
                                            type                     ::    #{@type}|
                                            operation_timeout        ::    #{@operation_timeout}|
                                            no_ssl_peer_verification ::    #{@no_ssl_peer_verification}|
					    port                     ::    #{@port}")


    connector_call = @call.connector(@connector_name)
	            .set("vm-id",@vm_id)
                    .set("target",@target)
                    .set("username",@username)
                    .set("password",@password)
                    .set("transport",@transport)
                    .set("type",@type)
		    .set("action",@action)
                    .set("port",@port)
                    .set("shell",@shell)
                    .set("operation_timeout",@operation_timeout)
                    .set("timeout",@request_timeout)
                
    if @request_timeout.nil? || @request_timeout.is_a?(String)
    @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
    @log.trace("Calling #{@connector_name} with given timeout #{@request_timeout.to_s}...")
        response = connector_call.timeout(@request_timeout).sync
    end
    #Winrm Connector Response Meta Parameters
    response_exitcode=response.exitcode           #Exit status code
    response_message=response.message            #Execution status message

    #Winrm Connector Response Parameters
    result = response.get("result")               #Response Body

    
    if response.exitcode == 0    
        @log.info("output: #{response}")
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} | 
                                                            message ::  #{response_message}")

        @output.set('exit-code', 0).set('message', 'success').setraw("data",result.to_s) 
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | 
                                                            message ::  #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:hyperv:operation:details_virtual_machine_hyperv.rb' flintbit...")
#end
