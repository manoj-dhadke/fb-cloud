require 'json'
@log.trace("Started execution'flint-o365:microsoft-cloud:user_account:get_all_user.rb' flintbit...") 
begin
     # Flintbit Input Parameters
     @connector_name = @input.get('connector_name')        # Name of the Connector                               
     @microsoft_id = @input.get("customer-id")             # id of the Microsoft Account
     @action = @input.get("action")                        

     @microsoftCloudActionUrl = '/MSCustomerSubscription/performOperations'    

     @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | MICROSOFT ID :: #{@microsoft_id}")

     response = @call.connector(@connector_name)
                     .set('action', @action)
                     .set('microsoft-id', @microsoft_id)        
                     .sync

     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message
     response_body = response.get("body")
     
     @log.info("RESPONSE :: #{response_body}")
     
     if response_exitcode==0
        @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
        response_body = JSON.parse(response.get('body'))
        @log.info("OUTPUT ::")
        @output.set("result::","Success")

       # @call.bit('flint-o365:http:http_request.rb').set('method', 'POST').set('url', @microsoftCloudActionUrl).timeout(120000).set('body', json_obj).sync   
     else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.exit(1, response_message)
      end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished execution 'flint-o365:microsoft-cloud:user_account:get_all_user.rb' flintbit...") # Execution Finished
