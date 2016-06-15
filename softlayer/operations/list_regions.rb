# begin
@log.trace("Started executing 'flint-cloud:softlayer:operations:list_regions.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name') # Name of the Softlayer Connector
    @action = 'list-regions' # Contains the name of the operation
    # optional
    @username = @input.get('username') # Username of softlayer account
    @apikey = @input.get('apikey') # apikey of softlayer account

    @request_timeout = @input.get('timeout') # timeout
    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | action :: #{@action}| username :: #{@username}|
    apikey :: #{@apikey}| timeout :: #{@request_timeout}")

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('apikey', @apikey)
                          .set('username', @username)

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{@request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    # Softlayer Connector Response Meta Parameters
    response_exitcode = response.exitcode           # Exit status code
    response_message = response.message             # Execution status message

    # Softlayer Connector Response Parameters
    result = response.get('list-regions') # Response body
    @log.info(result.to_s)
    if response.exitcode == 0

        @log.info("SUCCESS in executing Softlayer Connector where, exitcode :: #{response_exitcode} | message ::  #{response_message}")
        @log.info("Softlayer Response Body :: #{result}")
        @output.set('exit-code', response.exitcode)
        @output.set('message', response.message)
    # @output.setraw("response",response.to_s)
    else
        @log.error("ERROR in executing Softlayer Connector where, exitcode :: #{response_exitcode} | message ::  #{response_message}")
        @output.set('exit-code', response.exitcode)
        @output.set('message', response.message)
    end
rescue => e
    @log.error(e.message)
    @output.set('message', e.message).set('exit-code', -1)
    @log.info('output in exception')
end
@log.trace("Finished executing 'flint-cloud:softlayer:operations:list_regions.rb' flintbit...")
# end
