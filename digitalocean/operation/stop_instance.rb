# begin
@log.trace("Started executing 'flint-cloud:digitalocean:operation:stop_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name') # Name of the DigitalOcean Connector
    @action = @input.get('action') # Action (stop)
    @id = @input.get('id') # Id of the instance
    # optional
    @token = @input.get('token') # token(credential of account)
    @request_timeout = @input.get('timeout') # timeout

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} |action :: #{@action}| id :: #{@id}| token :: #{@token}|
    timeout :: #{@request_timeout}")

    connector_call = @call.connector(@connector_name)
                          .set('action', 'stop')
                          .set('id', @id)
                          .set('token', @token)

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{@request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    # DigitalOcean Connector Response Meta Parameters
    response_exitcode = response.exitcode           # Exit status code
    response_message = response.message             # Execution status message

    # DigitalOcean Connector Response Parameters
    actionId = response.get('action-id')           # Action id
    resourceId = response.get('resource-id')       # Machine id
    resourceType = response.get('resource-type')   # Machine type
    actionType = response.get('action-type')       # Action type(power_off)
    actionStatus = response.get('action-status')   # Action status

    if response.exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} Connector where, exitcode :: #{response_exitcode} | message ::  #{response_message}")
        @log.info("#{@connector_name} Action type :: #{actionType}Action id :: #{actionId}")
        @output.setraw('response', response.to_s).set('exit-code', 0).set('message', 'success')

    else
        @log.error("ERROR in executing #{@connector_name} Connector where, exitcode :: #{response_exitcode} | message ::  #{response_message}")
        @output.exit(1, response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'flint-cloud:digitalocean:operation:stop_instance.rb' flintbit...")
# end
