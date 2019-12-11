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
@log.trace("Started executing 'flint-cloud:softlayer:operations:describe_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name') # Name of the Softlayer Connector
    @action = 'details' # Contains the name of the operation: details
    @id = @input.get('id') # Id of the machine
    # optional
    @username = @input.get('username') # username of softlayer account
    @apikey = @input.get('apikey') # apikey of softlayer account
    @request_timeout = @input.get('timeout') # timeout

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} |action :: #{@action}|id :: #{@id} | username :: #{@username}|
    apikey :: #{@apikey}| timeout :: #{@request_timeout}")

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('id', @id.to_i)
                          .set('username', @username)
                          .set('apikey', @apikey)

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{@request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    @log.info("Connector response : #{response}")
    # Softlayer Connector Response Meta Parameters
    response_exitcode = response.exitcode           # Exit status code
    response_message = response.message             # Execution status message

    # Softlayer Connector Response Parameters
    result = response.get('vm-details') # Response Body

    if response.exitcode == 0
        @log.info("response : #{result}")
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.setraw('response', response.to_s).set('exit-code', 0).set('message', 'success')
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.setraw('response', response.to_s).set('exit-code', 1)
    end
rescue => e
    @log.error(e.message)
    @output.set('message', e.message).set('exit-code', -1)
    @log.info('output in exception')
end
@log.trace("Finished executing 'flint-cloud:softlayer:operation:describe_instance.rb' flintbit...")
# end
