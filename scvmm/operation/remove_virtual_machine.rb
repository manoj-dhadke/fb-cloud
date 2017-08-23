require 'json'
require 'rubygems'
#begin
@log.trace("Started executing 'fb-cloud:scvmm:operation:remove_virtual_machine.rb' flintbit...")
begin
    #Flintbit Input Parameters
    #Mandatory  
    @connector_name= @input.get("connector_name")                             #Name of the Connector
    @target= @input.get("target")               			                  #Target address
    @username = @input.get("username")               			              #Username
    @password = @input.get("password")               			              #Password
    @shell = "ps"               			                      #Shell Type
    @transport = @input.get("transport")               			              #Transport
    @vmidentifier = @input.get("identifier")          			                  #Virtual Machine name
    @command = "$VM = Get-SCVirtualMachine -Id  #{@vmidentifier} -VMMServer #{@target};Stop-SCVirtualMachine -VM $VM;Remove-SCVirtualMachine -VM $VM | convertto-json"                    #Command to run
    @operation_timeout = 80                                           		  #Operation Timeout
    @no_ssl_peer_verification = @input.get("no_ssl_peer_verification")        #SSL Peer Verification
    @port = @input.get("port")                                                #Port Number
    @request_timeout= @input.get("timeout")                                   #Timeout

    @log.info("Flintbit input parameters are,  connector name           ::    #{@connector_name} |
                                            target                   ::    #{@target} |
                                            username                 ::    #{@username}|
                                            password                 ::    #{@password} |
                                            shell                    ::    #{@shell}|
                                            vm-id                    ::     #{@vmidentifier}|
                                            transport                ::    #{@transport}|
                                            command                  ::    #{@command}|
                                            operation_timeout        ::    #{@operation_timeout}|
                                            no_ssl_peer_verification ::    #{@no_ssl_peer_verification}|
                                            port                     ::    #{@port}")


    if @vmidentifier == nil || @vmidentifier == ""
            @log.error("Please provide vm id to perform restart vm operation")
            @output.exit(1,"vm id is blank or not provided")
    end

    connector_call = @call.connector(@connector_name)
                    .set("target",@target)
                    .set("username",@username)
                    .set("password",@password)
                    .set("transport",@transport)
                    .set("command",@command)
                    .set("port",@port)
                    .set("shell",@shell)
                    .set("operation_timeout",@operation_timeout)
                    .set("timeout",@request_timeout)
                
    if @request_timeout.nil? || @request_timeout.is_a?(String)
    @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
    @log.trace("Calling #{@connector_name} with given timeout #{request_timeout.to_s}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    #Winrm Connector Response Meta Parameters
    response_exitcode=response.exitcode           #Exit status code
    response_message=response.message             #Execution status message

    #Winrm Connector Response Parameters
    result = response.get("result")               #Response Body


    if response.exitcode == 0
    
        @log.info("output"+result.to_s)
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} | 
                                                            message ::  #{response_message}")	
 	@output.set("exit-code",response_exitcode).set("message",response_message) 
        
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | 
                                                            message ::  #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:scvmm:operation:remove_virtual_machine.rb' flintbit...")
#end
