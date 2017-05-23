require 'json'

@log.trace("Started execution'flint-snow:microsoft-cloud:customer:subscription:sync.rb' flintbit...") # starting execution
begin
     # Flintbit Input Parameters

     # Mandatory
     @connector_name = 'office365' # Name of the office365 Connector
     @id = @input.get('customer-id') # id of the Microsoft Account
     @microsoftCloudActionUrl = '/MSCustomerSubscription/performOperations' #microsoft Action URl
     @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | Customer ID::#{@id}")

     # calling office365 connector
     response = @call.connector(@connector_name)
                     .set('action', 'get-all-customer-user-accounts')
                     .set('microsoft-id', @id)
                     .sync

     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message

     if response_exitcode.zero?

       # if exitcode is Zero then do following operations
       response_body_string = JSON.parse(response.get('body')) # parsing json string to JSON Object
       @output.set("result::","#{response_body_string}")
       all_subscription = response_body_string['items'] # fetching item array from body

       # iterating  item array and inserting customer id in each json object of item array
       all_subscription.each do |items|
           request_body = {}

           # request_body['customerId'] = @id # inserting customerId in the item array
           request_body['action'] = 'sync-users' # inserting action in the array
           request_body['customerId'] = @id

           # checking if the user have ad-ons
           if items.key?('parentSubscriptionId')
               request_body['subscription_add_on'] = items

           # if subscription does not have adons
           else
               request_body['subscription'] = items
           end
           # calling http_request flintbit to upload data on specified URl
           @call.bit('flint-snow:microsoft-cloud:customer:subscriptions:http_request.rb').set('method', 'POST').set('url', @microsoftCloudActionUrl).timeout(120000).set('body', request_body.to_json).sync
      end
     else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.exit(1, response_message)
end

 # if any Exception occur in the flintbit then it will catch by rescue
 rescue Exception => e
     @log.error(e.message)
     @output.set('exit-code', 1).set('message', e.message)

 end

@log.trace("Finished execution 'flint-snow:microsoft-cloud:customer:subscription:sync.rb' flintbit...") # Execution Finished
