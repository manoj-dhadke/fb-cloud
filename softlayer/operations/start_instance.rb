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
@log.trace("Started executing 'flint-cloud:softlayer:operation:start_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name') # Name of the Cloud Connector
    @action = 'start' # Contains the name of the operation
    @id = @input.get('id') # Id
    # optional
    @username = @input.get('username') # username of softlayer account
    @apikey = @input.get('apikey') # apikey of softlayer account
    @request_timeout = @input.get('timeout') # timeout

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | action :: #{@action}| id :: #{@id}|
    key :: #{@username}| secret :: #{@apikey}| timeout :: #{@request_timeout}")

    connector_call = @call.connector(@connector_name)
                          .set('action', 'start')
                          .set('id', @id.to_i)
                          .set('apikey', @apikey)
                          .set('username', @username)

    @log.info(" Connector call response  : #{connector_call}")

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
    result = response.get('power-on')               # vm power on state
    state = response.get('vm-state')                # vm state

    if response.exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} Connector where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @log.info("Softlayer Response Body :: #{result}")
        @output.setraw('response', response.to_s).set('exit-code', 0).set('message', 'success')

    else
        @log.error("ERROR in executing #{@connector_name} Connector where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.exit(1, response_message)
    end
rescue => e
    @log.error(e.message)
    @output.set('message', e.message).set('exit-code', -1)
    @log.info('output in exception')
end
@log.trace("Finished executing 'flint-cloud:softlayer:operation:start_instance.rb' flintbit...")
# end
