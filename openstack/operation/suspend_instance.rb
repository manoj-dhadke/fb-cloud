# begin
@log.trace("Started executing 'fb-cloud:openstack:operation:suspend_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')
    action = 'suspend-instance'
    @server_id = @input.get('server-id')
    @protocol = @input.get('protocol')
    @target = @input.get('target')
    @port = @input.get('port')
    @version = @input.get('version')
    @username = @input.get('username')
    @password = @input.get('password')
    @domain_id = @input.get('domain-id')
    #optional
    @project_id = @input.get('project-id')
    request_timeout = @input.get('timeout')

    @log.info("Flintbit input parameters are, action : #{action} | serverId : #{@server_id} | target : #{@target}")
    connector_call = @call.connector(connector_name)
                          .set('action', action)
                          .set('protocol', @protocol)
                          .set('username', @username)
                          .set('password', @password)
                          .set('domain-id', @domain_id)
                          .set('target', @target)
                          .set('port', @port)
                          .set('version', @version)

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "openstack connector name (connector_name)" to suspend server'
        end
    if @domain_id.nil? || @domain_id.empty?
        raise 'Please provide "openstack domain ID (domain_id)" to start server'
        end
    if @target.nil? || @target.empty?
        raise 'Please provide "openstack target (@target)" to  rename credentials'
    end

    if @username.nil? || @username.empty?
        raise 'Please provide "openstack username (@username)" to  rename credentials'
    end

    if @password.nil? || @password.empty?
        raise 'Please provide "openstack password (@password)" to  rename credentials'
    end

    if @server_id.nil? || @server_id.empty?
        raise 'Please provide "openstack domain ID (domain_id)" to suspend server'
    else
        connector_call.set('server-id', @server_id)
        end
    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(request_timeout).sync
    end

    response_exitcode = response.exitcode
    response_message = response.message

    @log.info('RESPONSE ' + response.to_s)

    is_success = response.get('is-success')
    fault = response.get('fault')
    code = response.get('code')

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('is-success', is_success)
        @log.info('is-success ' + is_success.to_s)
        @log.info('fault ' + fault.to_s)
        @log.info('code ' + code.to_s)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message).set('details',response.to_s)
     end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:openstack:operation:suspend_instance.rb' flintbit")
# end
