require 'json'
require 'rubygems'
#begin
@log.trace("Started executing 'fb-cloud:hyperv:operation:remove_virtual_machine.rb' flintbit...")
begin
    #Flintbit Input Parameters
    #Mandatory  
    @connector_name= @input.get("connector_name")                                          #Name of the Connector
    @vmname = @input.get("vmname")														   #Name of the vm
    @command = "powershell -Command \"&{Remove-VM #{@vmname} -f 2>&1 | ConvertTo-JSON}\""  #Command
    @protocol = @input.get("protocol")                                                     #Protocol
    #optional
    @hostname = @input.get("hostname")                          						   #hostname
    @password = @input.get("password")                              					   #password                             
    @user = @input.get("user")															   #username
    @request_timeout= @input.get("timeout")                     						   #timeout

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} |
                                            command ::       #{@command}|
                                            protocol ::      #{@protocol} |
                                            hostname ::      #{@hostname}|
                                            user ::          #{@user}|
                                            password ::      #{@password}|
                                            timeout ::       #{@request_timeout}")

    if @vmname == nil || @vmname == ""
            @log.error("Please provide vm name to perform remove vm operation")
            @output.exit(1,"vm name is blank or not provided")
    end

    connector_call = @call.connector(@connector_name)
                    .set("command",@command)
                    .set("protocol",@protocol)
                
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
    result = response.get("output")               #Response Body


    if response.exitcode == 0
    
        @log.info("output"+result.to_s)
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} | 
                                                            message ::  #{response_message}")
        
        @output.setraw("output",result.to_s)	
    
        
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | 
                                                            message ::  #{response_message}")
        @output.exit(1,response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
@log.trace("Finished executing 'fb-cloud:hyperv:operation:remove_virtual_machine.rb' flintbit...")
#end
