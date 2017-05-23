require 'json'
@log.trace("Started execution'flint-o365:microsoft-cloud:user_account:add_user.rb' flintbit...") 
begin
     # Flintbit Input Parameters
     @connector_name = @input.get('connector-name')        # Name of the Connector                               
     @microsoft_id = @input.get("customer-id")             # id of the Microsoft Account
     @action = 'add-user'				   #@input.get("action")                        
     @usage_location = @input.get("usage-location")
     @display_name = @input.get("display-name")
     @user_password = @input.get("user-password")
     @force_change_password = @input.get("force-change-password")
     @first_name = @input.get("first-name")  
     @last_name = @input.get("last-name")  
     @user_principal_name = @input.get("user-principal-name")

     @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | MICROSOFT ID :: #{@microsoft_id}")

     response = @call.connector(@connector_name)
                     .set('action', @action)
                     .set('microsoft-id', @microsoft_id)
                     .set('usage-location', @usage_location)
                     .set('display-name', @display_name)
                     .set('user-password', @user_password)
                     .set('force-change-password', @force_change_password)
                     .set('first-name', @first_name)
                     .set('last-name', @last_name)
                     .set('user-principal-name', @user_principal_name)           
                     .sync

     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message
     response_body = response.get("body")
     
     if response_exitcode==0
        @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
        @log.info("RESPONSE :: #{response_body}")
        @output.setraw("result::", response_body.to_json)
     else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.exit(1, response_message)
      end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished execution 'flint-o365:microsoft-cloud:user_account:add_user.rb' flintbit...") 
