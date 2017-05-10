# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:delete_classic_lb_listener.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name') # Name of the Amazon EC2 Connector
    name = @input.get('name') #Specifies name of load balancer to be deleted
    loadbalancer_type = @input.get('loadbalancer-type')
    action = "delete-classic-load-balancer-listener" # Specifies the name of the operation:delete-subnet
    listeners = @input.get('listeners')
    # Optional
    region = @input.get('region') # Amazon EC2 region (default region is "us-east-1")
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
    @access_key = @input.get('access-key')	# access key of aws-ec2 account
    @secret_key = @input.get('security-key')	# secret key aws-ec2 account

    @log.info("Flintbit input parameters are, connector_name:#{connector_name}  
                                                                                | action : #{action} 
                                                                                | name: #{name} 
                                                                                | listener ports: #{listeners}")
    connector_call = @call.connector(connector_name)
                          .set('action', action)
                          .set('load-balancer-name',name)
                          .set('access-key',@access_key)
                          .set('security-key',@secret_key)
                          .set('list-of-load-balancer-ports',listeners)
    
    #Cheking the region is not provided or not,if not then use default region as us-east-1
    if !region.nil? && !region.empty?
        response = connector_call.set('region', region)
    else
        @log.trace("region is not provided so using default region 'us-east-1'")
    end

    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(request_timeout).sync
    end

    response_exitcode = response.exitcode   # Exit status code
    response_message = response.message # Execution status messages
        @log.info("exitcode : #{response_exitcode} | message : #{response_message}")
# Cheking the response_exitcode,if it zero then show details and response_message otherwise show error_message to user
    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message', 'success')
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end

# if exception occured during execution then it will catch by rescue and it will show exception message to user
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:delete_classic_lb_listener.rb' flintbit")
# end
