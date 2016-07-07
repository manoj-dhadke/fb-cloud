# begin
@log.trace("Started executing 'flint-cloud:openstack-openstackClientV2:operation:delete_openstack_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')
    action = 'delete'
    @serverId = @input.get('serverid')
    @protocol = @input.get('protocol')
    @target = @input.get('target')
    @port = @input.get('port')
    @version = @input.get('version')
    @tenant = @input.get('tenant')
    @username = @input.get('username')
    @password = @input.get('password')

    # optional
    request_timeout = @input.get('timeout')
    @log.info("Flintbit input parameters are, action : #{action} | serverId : #{@serverId}")
    connector_call = @call.connector(connector_name).set('action', action).set('protocol', @protocol).set('username', @username).set('password', @password).set('tenant', @tenant).set('target', @target).set('port', @port).set('version', @version)

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "openstack connector name (connector_name)" to start server'
        end
    if @serverId.nil? || @serverId.empty?
        raise 'Please provide "openstack server ID (serverid)" to start server'
    else
        connector_call.set('serverid', @serverId)
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
        @output.set('exit-code', 1).set('message', response_message)

     end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)

end
@log.trace("Finished executing 'flint-cloud:openstackClientV2:operation:delete_openstack_instance.rb' flintbit")
# end
