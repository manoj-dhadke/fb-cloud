# begin
@log.trace("Started executing 'flint-cloud:digitalocean:operation:list_regions.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name')	# Name of the DigitalOcean Connector
    @action = 'list-regions'	# Action (list-regions)
    # optional
    @token = @input.get('token')	# token(credential of account)
    @request_timeout = @input.get('timeout')	# timeout

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | action :: #{@action}| token :: #{@token}|
    timeout :: #{@request_timeout}")

    connector_call = @call.connector(@connector_name).set('action', @action).set('token', @token)

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    # DigitalOcean Connector Response Meta Parameters
    response_exitcode = response.exitcode           # Exit status code
    response_message = response.message             # Execution status message

    # DigitalOcean Connector Response Parameters
    list = response.get('regions-list') # list of machine

    if response.exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @log.info("#{@connector_name} list of machine :: #{list}")
        @output.set('exit-code', 0).set('message', 'success').setraw('regions-list', list.to_s)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.set('exit-code', 1).set('message', response_message.to_s)
        # @output.exit(1,response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'flint-cloud:digitalocean:operation:list_regions.rb' flintbit...")
# end
