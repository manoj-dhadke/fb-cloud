# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:region_list.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @log.info('REGION LIST INPUT --> ' + @input.raw.to_s)
    connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
    action = 'get-regions'	# Specifies the name of the operation: start-instances
    access_key = @input.get('access-key')
    security_key = @input.get('security-key')

    # Optional

    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    @log.info("Flintbit input parameters are, action : #{action} ")

    connector_call = @call.connector(connector_name).set('action', action).set('access-key', access_key).set('security-key', security_key)

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)" to list Instances'
    end

    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(request_timeout).sync
    end

    # Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode	# Exit status code
    response_message = response.message	# Execution status messages

    # Amazon EC2 Connector Response Parameters
    region_set = response.get('region')	# Set of Amazon EC2 region

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message', 'success').setraw('region', region_set.to_s)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response.message)
        # @output.exit(1,response_message)														#Use to exit from flintbit
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:region_list.rb' flintbit")
# end
