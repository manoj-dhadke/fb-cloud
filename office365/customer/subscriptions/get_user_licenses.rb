require 'json'

@log.trace("Started execution'flint-snow:microsoft-cloud:customer:subscription:sync.rb' flintbit...") # starting execution
begin
     # Flintbit Input Parameters

     # Mandatory
     @connector_name = 'office365' # Name of the office365 Connector
     @id = @input.get('customer-id') # id of the Microsoft Account
     @userId=@input.get('user-id')

     @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | Customer ID::#{@id}")

     # calling office365 connector
     response = @call.connector(@connector_name)
                     .set('action', 'get-user-licenses')
                     .set('microsoft-id', @id)
                     .set('user-id',@userId)
                     .sync

     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message

     response_body_string = JSON.parse(response.get('body')) # parsing json string to JSON Object

     @log.info(response_body_string.to_s)

     if response_exitcode.zero?

         @log.info('success')

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
