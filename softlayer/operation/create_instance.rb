#begin
@log.trace("Started executing 'flint-cloud:softlayer:operations:create_instance.rb' flintbit...")
#Flintbit Input Parameters
#Mandatory
@connector_name= @input.get("connector_name")               #Name of the Softlayer Connector
@action = @input.get("action")                              #Action
@hostname = @input.get("host-name")                         #Hostname of the machine to be created
@domainname = @input.get("domain-name") 					#DomainName of the machine to be created
@cpu = @input.get("cpu")                                    #No of cpu required
@maxmemory = @input.get("max-memory")                       #Max memory required by machine
@datacenter = @input.get("datacenter")                      #Name of the datacenter where machine is created
@operating_system = @input.get("opearting-system")          #Name of the operating system which is to be in machine
#optional
@username = @input.get("username")                          #Username
@apikey = @input.get("apikey")                              #apikey
@request_timeout= @input.get("timeout")                     #timeout

@log.info("Flintbit input parameters are, connector name :: 	#{@connector_name} |
	                                       action ::        	#{@action}|
										   hostname ::      	#{@hostname}|
										   domainname ::    	#{@domainname}|
                                           cpu ::           	#{@cpu}|
                                           maxmemory ::     	#{@maxmemory}|
										   datacenter ::    	#{@datacenter}|
										   operating_system ::  #{@operating_system}|
                                           username ::      	#{@username}|
                                           apikey ::        	#{@apikey}|
                                           timeout ::       	#{@request_timeout}")

connector_call = @call.connector(@connector_name)
                  .set("action",@action)
				  .set("host-name",@hostname)
				  .set("domain-name",@domainname)
				  .set("cpu",@cpu)
			      .set("max-memory",@maxmemory)
			      .set("datacenter",@datacenter)
				  .set("opearting-system",@operating_system)
                  .set("apikey",@apikey)
                  .set("username",@username)


if @request_timeout.nil? || @request_timeout.is_a?(String)
   @log.trace("Calling #{@connector_name} with default timeout...")
	 response = connector_call.sync
else
   @log.trace("Calling #{@connector_name} with given timeout #{request_timeout.to_s}...")
	 response = connector_call.timeout(@request_timeout).sync
end

@log.info("Response : "+response.to_s)
#Softlayer Connector Response Meta Parameters
response_exitcode=response.exitcode           #Exit status code
response_message=response.message             #Execution status message

#Softlayer Connector Response Parameters
id = response.get("id")                       #Machine Id
domainName = response.get("domainName")       #Machine domainName

if response.exitcode == 0
	@log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} |
    	                                                   message ::  #{response_message}")
	@log.info("#{@connector_name} Machine  Id :: #{id.to_s} | Machine domainName ::#{domainName}")
    @output.setraw("response",response.to_s)

else
	@log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} |
		                                                  message ::  #{response_message}")
    @output.exit(1,response_message)
end
@log.trace("Finished executing 'flint-cloud:softlayer:operation:create_instance.rb' flintbit...")
#end
