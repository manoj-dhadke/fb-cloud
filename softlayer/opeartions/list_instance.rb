#begin
@log.trace("Started executing 'flint-cloud:softlayer:operation:list_instance.rb' flintbit...")
#Flintbit Input Parameters
#Mandatory 
@connector_name= @input.get("connector_name")               #Name of the Softlayer Connector
@action = @input.get("action")                              #Action
#optional
@username = @input.get("username")                          #Username
@apikey = @input.get("apikey")                              #apikey
                              
@request_timeout= @input.get("timeout")                     #timeout
@log.info("Flintbit input parameters are, connector name :: #{@connector_name} |
	                                       action ::        #{@action}|
                                           username ::      #{@username}|
                                           apikey ::        #{@apikey}|
                                           timeout ::       #{@request_timeout}")



 connector_call = @call.connector(@connector_name)
                  .set("action",@action)
                  .set("apikey",@apikey)
                  .set("username",@username)

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
result = response.get("vm-list")              #Response body     

if response.exitcode == 0
    result.each do |instance_id|
	@log.info("#{@connector_name} Instance  id : #{instance_id}")
end
	@log.info("SUCCESS in executing cloud Connector where, exitcode :: #{response_exitcode} | 
    	                                                   message ::  #{response_message}")
	@log.info("Softlayer Response Body :: #{result}")
    @output.setraw("response",response.to_s)
else
	@log.error("ERROR in executing cloud Connector where, exitcode :: #{response_exitcode} | 
		                                                  message ::  #{response_message}")
    @output.exit(1,response_message)
end
@log.trace("Finished executing 'flint-cloud:softlayer:operation:list_instance.rb' flintbit...")
#end
