require 'json'
@log.trace("Started execution'flint-o365:customer:subscription:suspend_subscription.rb' flintbit...")
begin

     @connector_name = @input.get('connector-name') 		# Name of Connector
     @action = 'suspend-subscription-add-on'				#@input.get('action')            		        
     @microsoft_id = @input.get('customer-id')		        # id of the Microsoft Account
     @subscription_id=@input.get('subscription-id')

     @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | Customer ID::#{@id} | Subscription Id :: #{@subscription_id} ")

     response = @call.connector(@connector_name)
                     .set('action', 'suspend-subscription')
                     .set('microsoft-id', @microsoft_id)
                     .set('subscription-id', @subscription_id)
                     .sync

     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message
     response_body     =  response.get('body')

     if response_exitcode==0     
         @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
         @log.info(response_body.to_s)
         @output.setraw("result",response_body.to_json)
     else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.exit(1, response_message)
     end

 rescue Exception => e
     @log.error(e.message)
     @output.set('exit-code', 1).set('message', e.message)

 end
@log.trace("Finished execution 'flint-o365:customer:subscription:suspend_subscription.rb' flintbit...") 
