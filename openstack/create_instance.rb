# begin

@log.trace("Started executing 'flint-cloud:openstack-openstackClientV2:operation:create_openstack_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    @log.info("Input for create instance flintbit :: #{@input}")
    # Mandatory Input Parameters
    connector_name = @input.get('connector_name')
    action = 'create'
    @target = @input.get('target')
    @username = @input.get('username')
    @password = @input.get('password')
    @port = @input.get('port')
    @protocol = @input.get('protocol')
    @version = @input.get('version')
    @tenant = @input.get('tenant')
    @servername = @input.get('servername')
    @flavorId = @input.get('flavorid')
    @imageId = @input.get('imageid')
    @networkId = @input.get('networkid')
    # optional
    request_timeout = @input.get('timeout')

    @log.info("Flintbit input parameters are, action : #{action} | servername : #{@servername} | flavorid : #{@flavorId} | imageid : #{@imageId} | networkid : #{@networkId}")

    @log.info('Calling openstack Connector :: ' + connector_name.to_s)
    connector_call = @call.connector(connector_name)
                          .set('action', action)
                          .set('target', @target)
                          .set('username', @username)
                          .set('password', @password)
                          .set('tenant', @tenant)
                          .set('port', @port)
                          .set('protocol', @protocol)
                          .set('version', @version)
                          .set('servername', @servername)
                          .set('flavorid', @flavorId)
                          .set('imageid', @imageId)
                          .set('networkid', @networkId)

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "openstack connector name (connector_name)" to create server'
        end
    if @servername.nil? || @servername.empty?
        raise 'Please provide "openstack server name (servername)" to create server'
    else
        connector_call.set('servername', @servername)
        end
    if @flavorId.nil? || @flavorId.empty?
        raise 'Please provide "openstack flavour Id (flavorid)" to create server'
    else
        connector_call.set('flavourid', @flavourId)
        end
    if @imageId.nil? || @imageId.empty?
        raise 'Please provide "openstack image Id (imageid)" to create server'
    else
        connector_call.set('imageid', @imageId)
        end
    if @networkId.nil? || @networkId.empty?
        raise 'Please provide "openstack network Id (networkid)" to create server'
    else
        connector_call.set('networkid', @networkId)
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

    serverid = response.get('serverid')

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('serverid', serverid.to_s)

    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).setraw('message', response_message)
     end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'flint-cloud:openstackClientV2:operation:create_openstack_instance.rb' flintbit")
# end
