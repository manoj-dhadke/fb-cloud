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
@log.trace("Started executing 'fb-cloud:digitalocean:operation:delete_instance.rb' flintbit...")
begin

    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name') # Name of the DigitalOcean Connector
    @action = 'delete' # Action (stop)
    @id = @input.get('id') # Id of the instance
    # optional
    @token = @input.get('token') # token(credential of account)
    @request_timeout = @input.get('timeout') # timeout

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | action :: #{@action}| id :: #{@id}| token :: #{@token}|
		timeout :: #{@request_timeout}")

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('id', @id)
                          .set('token', @token)

    if @connector_name.nil? || @connector_name.empty?
        raise 'Please provide "digitalocean (connector_name)" to terminate Instance'
    end

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{@request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    # DigitalOcean Connector Response Meta Parameters
    response_exitcode = response.exitcode           			# Exit status code
    response_message = response.message             			# Execution status message

    # DigitalOcean Connector Response Parameters
    requestaccess = response.get('request-access')          # Request access
    statuscode = response.get('status-code')                # Status code
    if response.exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message ::  #{response_message}")
        @log.info("#{@connector_name} Response Body Deleted :: #{requestaccess}")
        @output.setraw('request-access', response.to_s).set('exit-code', 0).set('message', 'success')
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message ::  #{response_message}")
        @output.exit(1, response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:digitalocean:operation:delete_instance.rb' flintbit...")
# end
