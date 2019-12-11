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
@log.trace("Started executing 'fb-cloud:openstack:operation:resume_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')
    action = 'resume-instance'
    @server_id = @input.get('server-id')
    @protocol = @input.get('protocol')
    @target = @input.get('target')
    @port = @input.get('port')
    @version = @input.get('version')
    @username = @input.get('username')
    @password = @input.get('password')
    @domain_id = @input.get('domain-id')
    @project_id = @input.get('project-id')
    
    # optional
    request_timeout = @input.get('timeout')

    @log.info("Flintbit input parameters are, action : #{action} | serverId : #{@serverId}")
    connector_call = @call.connector(connector_name)
                          .set('action', action)
                          .set('protocol', @protocol)
                          .set('username', @username)
                          .set('password', @password)
                          .set('domain-id', @domain_id)
                          .set('target', @target)
                          .set('port', @port.to_i)
                          .set('version', @version)

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "openstack connector name (connector_name)" to resume server'
        end

    if @domain_id.nil? || @domain_id.empty?
        raise 'Please provide "openstack domain ID (domain_id)" to resume server'
    end

    if @project_id.nil? || @project_id.empty?
        raise 'Please provide "openstack Project ID (@project_id)" to resume server'
    else
        connector_call.set('project-id', @project_id)
    end  

    if @target.nil? || @target.empty?
        raise 'Please provide "openstack target (@target)" to resume server'
    end

    if @username.nil? || @username.empty?
        raise 'Please provide "openstack username (@username)" to resume server'
    end

    if @password.nil? || @password.empty?
        raise 'Please provide "openstack password (@password)" to resume server'
    end

    if @server_id.nil? || @server_id.empty?
        raise 'Please provide "openstack server ID (server-id)" to resume server'
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
@log.trace("Finished executing 'fb-cloud:openstack:operation:resume_instance.rb' flintbit")
# end
