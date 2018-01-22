# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:stop_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # mandatory
    connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
    action = 'stop-instances'	# stop Amazon EC2 instance action
    instance_id = @input.get('instance-id')	# Amazon Instance ID to stop one or more Instances
    @access_key = @input.get('access-key')
    @secret_key = @input.get('security-key')
    # optional
    region = @input.get('region')	# Amazon EC2 region (default region is 'us-east-1')
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds

    @log.info("Flintbit input parameters are, action : #{action} | instance_id : #{instance_id} | region : #{region}")

    connector_call = @call.connector(connector_name).set('action', action).set('access-key', @access_key).set('security-key', @secret_key)

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)" to stop Instance'
    end

    if instance_id.nil? || instance_id.empty?
        raise 'Please provide "Amazon instance ID (instance_id)" to stop Instance'
    else
        connector_call.set('instance-id', instance_id)
    end

    if !region.nil? && !region.empty?
        connector_call.set('region', region)
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

    # Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode              	        # Exit status code
    response_message = response.message                         # Execution status messages

    # Amazon EC2 Connector Response Parameters
    instances_set = response.get('stop-instance-list') # Set of Amazon EC2 stopped instances

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        instances_set.each do |instance_id|
            @log.info("Amazon EC2 Instance current state : #{instance_id.get('current-state')} | previous state : #{instance_id.get('previous-state')} |
        		Instance ID : #{instance_id.get('instance-id')}")
        end
        @user_message = "Successfully stopped AWS instance: #{instance_id} "
        @output.set('exit-code', 0).setraw('stopped-instances', instances_set.to_s).set('user_message',@user_message)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        response=response.to_s
        @user_message = "Failed to stop AWS instance: #{instance_id} "
        if !response.empty?
        @output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s).set('user_message',@user_message)
        else
        @output.set('message', response_message).set('exit-code', 1).set('user_message',@user_message)
        end
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:stop_instance.rb' flintbit")
# end
