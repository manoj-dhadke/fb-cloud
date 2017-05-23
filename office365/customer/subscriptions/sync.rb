require 'json'

@log.trace("Started execution'flint-o365:customer:subscription:sync.rb' flintbit...") 
begin

     # Mandatory
     @connector_name = @input.get('connector-name')			 # Name of the office365 Connector
     @action = 'get-all-subscriptions'
     @id = @input.get('customer-id') 					 # id of the Microsoft Account

     @microsoftCloudActionUrl = '/MSCustomerSubscription/performOperations'

     @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | Customer ID::#{@id}")

     response = @call.connector(@connector_name)
                     .set('action', @action)
                     .set('microsoft-id', @id)
                     .sync

     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message
     
     if response_exitcode==0
         
         response_body_string = JSON.parse(response.get('body')) # parsing json string to JSON Object
         all_subscription = response_body_string['items'] # fetching item array from body

         # iterating  item array and inserting customer id in each json object of item array
         all_subscription.each do |items|
             request_body = {}

             # request_body['customerId'] = @id # inserting customerId in the item array
             request_body['action'] = 'sync-subscriptions' # inserting action in the array
             request_body['customerId'] = @id
             # checking if the user have ad-ons
             if items.key?('parentSubscriptionId')
                 request_body['subscription-add-on'] = items
             else
                 request_body['subscription'] = items
             end
           @call.bit('flint-o365:http:http_request.rb').set('method', 'POST').set('url', @microsoftCloudActionUrl).timeout(120000).set('body',request_body.to_json).sync
             @log.info("#{request_body}");
         end
           else
             @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
             @output.exit(1, response_message)
           end
rescue Exception => e
     @log.error(e.message)
     @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished execution 'flint-o365:customer:subscription:sync.rb' flintbit...") 
