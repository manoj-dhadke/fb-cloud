require 'json'
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create_classic_lb_listeners.rb' flintbit...")
# Flintbit Input Parameters
# Mandatory
connector_name = @input.get('connector_name')	      # Name of the Amazon EC2 Connector
load_balancer_name = @input.get('name')
listener_array = @input.get('listeners')       # JSONArray of listners
action = 'create-listener-for-classic-load-balancer'

# Optional
    region = @input.get('region') # Amazon EC2 region (default region is "us-east-1")
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
    @access_key = @input.get('access-key')	# access key of aws-ec2 account
    @secret_key = @input.get('security-key')	# secret key aws-ec2 account

@log.info("Flintbit input parameters are, action : #{action}
                                                            | Load Balancer Name : #{load_balancer_name}
                                                            | Listeners : #{listener_array}")
if !load_balancer_name.nil? && !load_balancer_name.empty?

		connector_call = @call.connector(connector_name)
		                          .set('action', action)
		                          .set('load-balancer-name',load_balancer_name)
			                      .set('listeners',listener_array)
			                      .set('access-key', @access_key)
                          		  .set('security-key', @secret_key)

        #Cheking the region is not provided or not,if not then use default region as us-east-1
    if !region.nil? && !region.empty?
        connector_call.set('region', region)
    else
        @log.trace("region is not provided so using default region 'us-east-1'")
    end

    # if the request_timeout is not provided then call connector with default time-out otherwise call connector with given request time-out
    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(request_timeout).sync
    end

else
	raise "Please provide load balancer name"
end

		@log.info("RESPONSE OF CREATE LOAD BALANCER>>>>#{response}")

if response.exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
    @output.set('message', response.message).set('exit-code', 0)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
    response=response.to_s
    if !response.empty?
    @output.set('message', response.message).set('exit-code', 1).setraw('error-details',response.to_s)
    else
    @output.set('message', response.message).set('exit-code', 1)
    end
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:create_classic_lb_listeners.rb' flintbit")
# end
