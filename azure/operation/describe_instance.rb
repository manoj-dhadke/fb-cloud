# begin
@log.trace("Started executing 'fb-cloud:azure:operation:describe_instance_info.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name')
    @action = 'describe-instance'
    @instance_name = @input.get('instance-name')
    @group_name = @input.get('group-name')

    # Optional
    @request_timeout = @input.get('timeout')
    @key = @input.get('key')
    @tenant_id = @input.get('tenant-id')
    @subscription_id = @input.get('subscription-id')
    @client_id = @input.get('client-id')

    @log.info("Flintbit input parameters are, action : #{@action} | Group name : #{@group_name} | Name : #{@instance_name}")

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('tenant-id', @tenant_id)
                          .set('subscription-id', @subscription_id)
                          .set('key', @key)
                          .set('client-id', @client_id)
                          .set('instance-name',@instance_name)
                          .set('group-name',@group_name)

    if @connector_name.nil? || @connector_name.empty?
        raise 'Please provide "MS Azure connector name (connector_name)" to reboot Instance'
    end

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{@request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    # Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode	# Exit status code
    response_message = response.message	# Execution status messages

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message', response_message).set('instance-details',response.get('instance-details'))
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:describe_instance_info.rb' flintbit")
# end
