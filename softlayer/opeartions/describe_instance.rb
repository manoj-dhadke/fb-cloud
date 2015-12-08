#begin
@log.trace("Started executing 'flint-cloud:softlayer:operation:describe_instance.rb' flintbit...")
#Flintbit Input Parameters
#Mandatory  
@connector_name= @input.get("connector_name")               #Name of the Softlayer Connector
@action = @input.get("action")                              #Action
@id = @input.get("id")                                      #Id of the machine
#optional
@username = @input.get("username")                          #username
@apikey = @input.get("apikey")                              #apikey                             
@request_timeout= @input.get("timeout")                     #timeout

@log.info("Flintbit input parameters are, connector name :: #{@connector_name} |
	                                       action ::        #{@action}|
                                           id ::            #{@id} |
                                           username ::      #{@username}|
                                           apikey ::        #{@apikey}|
                                           timeout ::       #{@request_timeout}")

connector_call = @call.connector(@connector_name)
                  .set("action",@action)
                  .set("id",@id)
                  .set("username",@username)
                  .set("apikey",@apikey)

if @request_timeout.nil? || @request_timeout.is_a?(String)
   @log.trace("Calling #{@connector_name} with default timeout...")
	 response = connector_call.sync
else
   @log.trace("Calling #{@connector_name} with given timeout #{request_timeout.to_s}...")
	 response = connector_call.timeout(@request_timeout).sync
end

#Softlayer Connector Response Meta Parameters
response_exitcode=response.exitcode           #Exit status code
response_message=response.message             #Execution status message

#Softlayer Connector Response Parameters
result = response.get("vm-details")           #Response Body

if response.exitcode == 0
    @log.info("response"+result.to_s)
	@log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} | 
    	                                                   message ::  #{response_message}")

    @output.setraw("response",response.to_s)
else
	@log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | 
		                                                  message ::  #{response_message}")
    @output.exit(1,response_message)
    end
@log.trace("Finished executing 'flint-cloud:softlayer:operation:describe_instance.rb' flintbit...")
#end
