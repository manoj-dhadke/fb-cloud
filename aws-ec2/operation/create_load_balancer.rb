require 'json'
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create_load_balancer.rb' flintbit...")
# Flintbit Input Parameters
# Mandatory
connector_name = @input.get('connector_name')	      # Name of the Amazon EC2 Connector
action = 'create-load-balancer'                    # Specifies the name of the operation: create-security-group
load_balancer_name = @input.get('name')
availabilty_zones_array = @input.get('availabilityzones-array') # Array of Availibity zones Amazon EC2
listener_array = @input.get('listener-array')       # JSONArray of listners
subnet_array = @input.get('subnet-array')           # Array of subnets on which we want to connect load balancer
region = @input.get('region')
# Optional
@access_key = @input.get('access-key')
@secret_key = @input.get('security-key')
request_timeout = @input.get('timeout')
# @input.get('timeout')	            # Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)


@log.info("Flintbit input parameters are, action : #{action} |  Load Balancer Name : #{load_balancer_name} | Availability zones : #{availabilty_zones_array} | Subnets : #{subnet_array} | Listeners : #{listener_array}")
if !load_balancer_name.nil? && !load_balancer_name.empty?
	if !listener_array.nil? && !listener_array.empty?

		connector_call = @call.connector(connector_name)
		                          .set('action', action)
		                          .set('name',load_balancer_name)
		                          .set('access-key', @access_key)
		                          .set('security-key', @secret_key)
			                      .set('listeners-array',listener_array)

		if !subnet_array.nil? && subnet_array.empty?
		    connector_call.set('subnet-array',subnet_array).timeout(request_timeout)
		else !availabilty_zones_array.nil? && !availabilty_zones_array.empty?
		    connector_call.set('availabilty-zones-array',availabilty_zones_array).timeout(request_timeout)
		end

		if !request_timeout.nil? && !request_timeout.empty?
			connector_call.timeout(request_timeout)
		else
			connector_call.timeout(120000)
		end

		if !region.nil? && !region.empty?
	         response = connector_call.set('region', region).sync
	    else
	    	response = connector_call.sync
	        @log.trace("region is not provided so using default region 'us-east-1'")
	    end
	else
	@log.error("Error: At 'listener_array' #{listener_array}. Please provide listener.")
	end
else
	@log.error("Error: At 'Load balancer name' #{load_balancer_name}. Please provide load balancer name.")
end

@log.info("RESPONSE OF CREATE LOAD BALANCER>>>>#{response}")

# Amazon EC2 Connector Response Meta Parameters
response_exitcode = response.exitcode	# Exit status code
response_message = response.message	# Execution status messages

if response_exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
    @output.set('message', response_message)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
    @output.set('message', response_message)
    # @output.exit(1,response_message)						#Use to exit from flintbit
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:create_load_balancer.rb' flintbit")
# end
