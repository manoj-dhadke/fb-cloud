require 'json'
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create_load_balancer.rb' flintbit...")
# Flintbit Input Parameters
# Mandatory
connector_name = @input.get('connector_name')	      # Name of the Amazon EC2 Connector
action = 'create-load-balancer'                    # Specifies the name of the operation: create-security-group
load_balancer_name = @input.get('load-balancer-name')
availabilty_zones_array = @input.get('availabilityzones-array') # Array of Availibity zones Amazon EC2
listener_array = @input.get('listener-array')       # JSONArray of listners
subnet_array = @input.get('subnet-array')           # Array of subnets on which we want to connect load balancer

# Optional
@access_key = @input.get('access-key')
@secret_key = @input.get('security-key')
request_timeout = 120000
# @input.get('timeout')	            # Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)


@log.info("Flintbit input parameters are, action : #{action} |  Load Balancer Name : #{load_balancer_name} | Availability zones : #{availabilty_zones_array} | Subnets : #{subnet_array} | Listeners : #{listener_array}")

if !listener_array.nil? && !listener_array.empty?

	if !subnet_array.nil? && subnet_array.empty?
	    connector_call = @call.connector(connector_name).set('action', action).set('load-balancer-name',load_balancer_name).set('access-key', @access_key).set('security-key', @secret_key)
		             .set('listeners-array',listener_array).set('subnet-array',subnet_array).set('availabilty-zones-array',availabilty_zones_array).timeout(request_timeout).sync
	else !availabilty_zones_array.nil? && !availabilty_zones_array.empty?
	    connector_call = @call.connector(connector_name).set('action', action).set('load-balancer-name',load_balancer_name).set('access-key', @access_key).set('security-key', @secret_key)
		             .set('listeners-array',listener_array).set('subnet-array',subnet_array).set('availabilty-zones-array',availabilty_zones_array).timeout(request_timeout).sync
	end
else
@log.error("Error: Null at 'listener_array' #{listener_array}. Please provide listener.")
end

@log.info"RESPONSE OF CREATE LOAD BALANCER>>>>#{connector_call}"


# Amazon EC2 Connector Response Meta Parameters
response_exitcode = connector_call.exitcode	# Exit status code
response_message = connector_call.message	# Execution status messages

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
