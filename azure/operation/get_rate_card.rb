# begin
@log.trace("Started executing 'fb-cloud:azure:operation:get_rate_card.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name')
    @offer_durable_id = @input.get('offer-durable-id')
    @currency = @input.get('currency');
    @local = @input.get('local')
    @region_info = @input.get('region-info')
    @action = 'rate-card'

    # Optional
    @request_timeout = 180000
    @key = @input.get('key')
    @tenant_id = @input.get('tenant-id')
    @subscription_id = @input.get('subscription-id')
    @client_id = @input.get('client-id')

    @log.info("Flintbit input parameters are, action : #{@action} | Group id : #{@group_id} ")

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('tenant-id', @tenant_id)
                          .set('subscription-id', @subscription_id)
                          .set('key', @key)
                          .set('client-id', @client_id)
                          .set('group-id',@group_id)
                          .set('offer-durable-id',@offer_durable_id)
                          .set('currency',@currency)
                          .set('local',@local)
                          .set('region-info',@region_info)

    if @connector_name.nil? || @connector_name.empty?
        raise 'Please provide "MS Azure connector name (connector_name)" to get billing rate card details'
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
        @output.set('exit-code', 0).set('message', response_message).setraw('rate-card',response.get('body'))
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:get_rate_card.rb' flintbit")
# end
