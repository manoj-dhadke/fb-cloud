#begin
@log.trace("Started executing 'flint-cloud:aws-ec2:operation:list_instances.rb' flintbit...")
begin
#Flintbit Input Parameters
#Mandatory
connector_name = @input.get("connector_name")             		#Name of the Amazon EC2 Connector
action = "list"                                					#Specifies the name of the operation: start-instances
@access_key = @input.get("access-key")
@secret_key = @input.get("security-key")

#Optional
region = @input.get("region")									#Amazon EC2 region (default region is 'us-east-1')
request_timeout = @input.get("timeout")							#Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

@log.info("Flintbit input parameters are, action : #{action} | region : #{region}")

connector_call = @call.connector(connector_name).set("action",action).set("access-key",@access_key).set("security-key",@secret_key)
                
if connector_name.nil? || connector_name.empty?
   raise 'Please provide "Amazon EC2 connector name (connector_name)" to list Instances'
end

if !region.nil? && !region.empty?
   connector_call.set("region",region)
else
   @log.trace("region is not provided so using default region 'us-east-1'")     
end

if request_timeout.nil? || request_timeout.is_a?(String)
   @log.trace("Calling #{connector_name} with default timeout...")
	 response = connector_call.sync
else
   @log.trace("Calling #{connector_name} with given timeout #{request_timeout.to_s}...")
	 response = connector_call.timeout(request_timeout).sync
end

#Amazon EC2 Connector Response Meta Parameters
response_exitcode = response.exitcode						#Exit status code
response_message = response.message							#Execution status messages

#Amazon EC2 Connector Response Parameters
instances_set=response.get("instance-list")					#Set of Amazon EC2 instances

if response_exitcode == 0
	@log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
	@output.set("exit-code",0).setraw("instance-list",instances_set.to_s)
else
	@log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")  
	@output.set("exit-code",1).set("message",response_message)
	#@output.exit(1,response_message)														#Use to exit from flintbit
end
rescue Exception => e
	@log.error(e.message)
	@output.set("exit-code",1).set("message",e.message)
end
  @log.trace("Finished executing 'flint-cloud:aws-ec2:operation:list_instances.rb' flintbit")
#end
