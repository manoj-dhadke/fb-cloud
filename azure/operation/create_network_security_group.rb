require 'json'
@log.trace("Started executing 'fb-cloud:azure:operation:create_subnet.rb' flintbit...")

@connector_name = 'msazure' # name of Azure connector

connector_call = @call.connector(@connector_name)
                          .set('action', 'add-security-group')
                        response = connector_call.sync







    if response.exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
        @output.set('exit-code', 0).set('message', response.message)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
        @output.set('exit-code', 1).set('message', response.message)
    end

@log.trace("Finished executing 'fb-cloud:azure:operation:create_subnet.rb' flintbit")
