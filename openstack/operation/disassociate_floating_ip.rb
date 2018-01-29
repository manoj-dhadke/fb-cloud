# begin
@log.trace("Started executing 'fb-cloud:openstack:operation:disassociate_floating_ip.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')
    action = 'disassociate-floating-ip'
    @serverId = @input.get('server-id')
    @floating_ip = @input.get('floating-ip')
    @protocol = @input.get('protocol')
    @target = @input.get('target')
    @port = @input.get('port')
    @version = @input.get('version')
    @domain_id = @input.get('domain-id')
    @username = @input.get('username')
    @password = @input.get('password')
    @project_id = @input.get('project-id')

    #Optional
    request_timeout = @input.get('timeout')
   

    @log.info("Flintbit input parameters are, action : #{action} | serverId : #{@serverId} | floating-ip : #{@floating_ip }")
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
        raise 'Please provide "openstack connector name (connector_name)" to disassociate floating ip from the server'
    end
  
    if @domain_id.nil? || @domain_id.empty?
        raise 'Please provide "openstack domain id (@domain_id)"  to disassociate floating ip from the server'
    end

    if @project_id.nil? || @project_id.empty?
        raise 'Please provide "project id (@project_id)"  to disassociate floating ip from the server'
    else
        connector_call.set('project-id', @project_id)
    end

     if @target.nil? || @target.empty?
        raise 'Please provide "openstack target (@target)" to disassociate floatin ip from the server'
    end

     if @username.nil? || @username.empty?
        raise 'Please provide "openstack username (@username)" to disassociate floating ip from the server'
    end

    if @password.nil? || @password.empty?
        raise 'Please provide "openstack password (@password)"  to disassociate floating ip from the server'
    end
    if @serverId.nil? || @serverId.empty?
        raise 'Please provide "openstack server ID (server-id)" to disassociate floating ip from the server'
    else
        connector_call.set('server-id', @serverId)
    end

    if @floating_ip.nil? || @floating_ip.empty?
        raise 'Please provide "openstack floating ip (floating-ip)" to disassociate floating ip from the server'
    else
        connector_call.set('floating-ip', @floating_ip)
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


    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message',response_message)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)

    end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)

end
@log.trace("Finished executing 'fb-cloud:openstack:operation:disassociate_floating_ip.rb' flintbit")
# end
