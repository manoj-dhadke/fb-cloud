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
@log.trace("Started executing 'fb-cloud:azure:operation:add_backend_pool.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name')
    @group_name = @input.get('group-name')
    @load_balancer_name = @input.get('load-balancer-name')
    @backend_pool_name = @input.get('backend-pool-name')
    @network_interface_id = @input.get('network-interface-id')
    @action = 'add-backend-pool'

    # Optional
    @request_timeout = 180000
    @key = @input.get('key')
    @tenant_id = @input.get('tenant-id')
    @subscription_id = @input.get('subscription-id')
    @client_id = @input.get('client-id')

    @log.info("Flintbit input parameters are,connector-name:#{@connector_name} | action : #{@action}
    | group-name :#{@group_name} | load-balancer-name : #{@load_balancer_name} | backend-pool-name:#{@backend_pool_name} ")


    if @connector_name.nil? || @connector_name.empty?
        raise 'Please provide "MS Azure connector name (connector_name)" to add backend pool to load balancer'
    end


    if @group_name.nil? || @group_name.empty?
        raise 'Please provide "MS Azure group name (@group_name)" to add backend pool to load balancer '
    end


    if @load_balancer_name.nil? || @load_balancer_name.empty?
        raise 'Please provide "MS Azure load balancer name (@load_balancer_name)" to add backend pool to load balancer'
    end


    if @backend_pool_name.nil? || @backend_pool_name.empty?
        raise 'Please provide "MS Azure backend pool name (@backend_pool_name)"to add backend pool to load balancer'
    end



    if @network_interface_id.nil? || @network_interface_id.empty?
        raise 'Please provide "MS Azure network interface id(@network_interface_id)"to add backend pool to load balancer'
    end


      connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('tenant-id', @tenant_id)
                          .set('subscription-id', @subscription_id)
                          .set('key', @key)
                          .set('client-id', @client_id)
                          .set('group-name', @group_name)
                          .set('load-balancer-name', @load_balancer_name)
                          .set('backend-pool-name', @backend_pool_name)
                          .set('network-interface-id', @network_interface_id)

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
        @output.set('exit-code', 0).set('message', response_message)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished executing 'fb-cloud:azure:operation:add_backend_pool.rb' flintbit")
# end
