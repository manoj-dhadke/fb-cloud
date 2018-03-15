# begin
@log.trace("Started executing 'fb-cloud:openstack:operation:list_floating_ips.rb' flintbit...")
begin
     # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')
    action = 'list-floating-ips'
    @protocol = @input.get('protocol')
    @target = @input.get('target')
    @port = @input.get('port')
    @version = @input.get('version')
    @username = @input.get('username')
    @password = @input.get('password')
    @domain_id = @input.get('domain-id')
    @project_id = @input.get('project-id')
 
    #optional   
    request_timeout = @input.get('timeout')

    connector_call = @call.connector(connector_name)
			  .set('action', action)
 			  .set('protocol', @protocol)
			  .set('target', @target)
			  .set('password', @password)
			  .set('domain-id', @domain_id)
			  .set('port', @port.to_i)
			  .set('version', @version)
			  .set('username', @username)
			  

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "openstack connector name (connector_name)" to list floating ips'
    end

    if @domain_id.nil? || @domain_id.empty?
        raise 'Please provide "openstack domain id (@domain_id)" to list floating ips'
    end

     if @target.nil? || @target.empty?
        raise 'Please provide "openstack target (@target)" to list floating ips'
    end

     if @username.nil? || @username.empty?
        raise 'Please provide "openstack username (@username)"to list floating ips'
    end

    if @password.nil? || @password.empty?
        raise 'Please provide "openstack password (@password)" to list floating ips'
    end
 
    if @project_id.nil? || @project_id.empty?
        raise 'Please provide "openstack project id (project-id)" to list floating ips'
    else
        connector_call.set('project-id',@project_id)
    end

    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(request_timeout).sync
    end

    #fetching response 
    response_exitcode = response.exitcode
    response_message = response.message

    floating_ip_list=response.get('floating-ip-list')

    
    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message',response_message).set('floating-ip-list',floating_ip_list)

    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)

     end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)

end

@log.trace("Finished executing 'fb-cloud:openstack:operation:list_floating_ips.rb' flintbit")
# end
