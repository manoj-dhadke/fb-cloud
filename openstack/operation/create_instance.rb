=begin
##########################################################################
#
#  INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
#  __________________
# 
#  (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
#  All Rights Reserved.
#  Product / Project: Flint IT Automation Platform
#  NOTICE:  All information contained herein is, and remains
#  the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
#  The intellectual and technical concepts contained
#  herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
#  Dissemination of this information or any form of reproduction of this material
#  is strictly forbidden unless prior written permission is obtained
#  from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
=end

# begin

@log.trace("Started executing 'fb-cloud:openstack:operation:create_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    @log.info("Input for create instance flintbit :: #{@input}")
    # Mandatory Input Parameters
    connector_name = @input.get('connector_name')
    action = 'create-instance'
    @target = @input.get('target')
    @username = @input.get('username')
    @password = @input.get('password')
    @port = @input.get('port')
    @protocol = @input.get('protocol')
    @version = @input.get('version')
    @domain_id = @input.get('domain-id')
    @servername = @input.get('server-name')
    @flavorId = @input.get('flavor-id')
    @imageId = @input.get('image-id')
    @networkId = @input.get('network-id')
    @project_id = @input.get('project-id')

    # optional
    request_timeout = @input.get('timeout')
    

    @log.info("Flintbit input parameters are, action : #{action} | servername : #{@servername} | flavorid : #{@flavorId} | imageid : #{@imageId} | networkid : #{@networkId}")

    @log.info('Calling openstack Connector :: ' + connector_name.to_s)
    connector_call = @call.connector(connector_name)
                          .set('action', action)
                          .set('target', @target)
                          .set('username', @username)
                          .set('password', @password)
                          .set('port', @port)
                          .set('protocol', @protocol)
                          .set('version', @version)                         
			              

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "openstack connector name (connector_name)" to create server'
    end
	
    if @project_id.nil? || @project_id.empty?
        raise 'Please provide "project id (@project_id)" to create server'
    else
        connector_call.set('project-id', @project_id)
    end

    if @domain_id.nil? || @domain_id.empty?
        raise 'Please provide "openstack domain id (@domain_id)" to create server'
    else
        connector_call.set('domain-id', @domain_id)
    end

    if @servername.nil? || @servername.empty?
        raise 'Please provide "openstack server name (server-name)" to create server'
    else
        connector_call.set('server-name', @servername)
    end

    if @flavorId.nil? || @flavorId.empty?
        raise 'Please provide "openstack flavor Id (flavor-id)" to create server'
    else
        connector_call.set('flavor-id', @flavorId)
     end

    if @imageId.nil? || @imageId.empty?
        raise 'Please provide "openstack image Id (image-id)" to create server'
    else
        connector_call.set('image-id', @imageId)
    end

    if @networkId.nil? || @networkId.empty?
        raise 'Please provide "openstack network Id (network-id)" to create server'
    else
        connector_call.set('network-id', @networkId)
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
        @output.set('exit-code', 0).set('message',response_message)

    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
     end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:openstack:operation:create_instance.rb' flintbit")
# end
