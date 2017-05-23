require 'json'
@log.trace("Started execution'flint-o365:microsoft-cloud:user-accounts:license:remove_licenses.rb' flintbit...") 
begin
     @connector_name = @input.get('connector-name')        # Name of the Connector
     @action = 'remove-liciense'						   #@input.get("action")                        
     @microsoft_id = @input.get("customer-id")             # id of the Microsoft Account
     @user_id = @input.get('user-id')                      #id of the user Account
     @license_id = @input.get('license-id')              

     @log.info("Flintbit input parameters are, Connector Name:#{@connector_name} | USER ID:#{@user_id} | MICROSOFT ID:#{@microsoft_id} | License Id :#{@license_id}")

     response = @call.connector(@connector_name)
                     .set('action', @action)
                     .set('microsoft-id', @microsoft_id)
                     .set('user-id', @user_id)
                     .set('license-id', @license_id)
                     .sync

     response_exitcode = response.exitcode 	# Exit status code
     response_message =  response.message 	# Execution status message
     response_body = response.get('body') 
     
      if response_exitcode==0

         @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
         @log.info("RESPONSE :: #{response_body}")
         @output.setraw("result", response_body.to_json)
      else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.exit(1, response_message)
      end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished execution 'flint-o365:microsoft-cloud:user-accounts:license:remove_licenses.rb' flintbit...") 
