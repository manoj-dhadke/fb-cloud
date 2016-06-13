# begin
begin
    @log.trace("Started executing 'flint-cloud:digitalocean:operation:describe_instance.rb' flintbit...")
    # Flintbit Input Parameters

    # Mandatory
    @connector_name = @input.get('connector_name')	# Name of the DigitalOcean Connector
    @action = 'detail'	# Action(detail)
    @id = @input.get('id')	# Id of the machine

    # optional
    @token = @input.get('token')	# token(credential of account)
    @request_timeout = @input.get('timeout')	# timeout

    @log.info("Flintbit input parameters are, connector name : #{@connector_name} | action : #{@action}| id : #{@id} |
     token : #{@token} | timeout : #{@request_timeout}")

    connector_call = @call.connector(@connector_name).set('action', @action).set('id', @id.to_i).set('token', @token)

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    # DigitalOcean Connector Response Meta Parameters

    response_exitcode = response.exitcode	# Exit status code
    response_message = response.message	# Execution status message

    # DigitalOcean Connector Response Parameters

    droplet_info = response	# Response Body

    if response.exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message ::  #{response_message}")

        @output.set('exit-code', 0).set('message', 'success').setraw('droplet-info', droplet_info.to_s)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message ::  #{response_message}")
        @output.set('exit-code', 1).setraw('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'flint-cloud:digitalocean:operation:describe_instance.rb' flintbit...")
# end
