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

require 'json'
@log.trace("Started execution'flint-snow:microsoft-cloud:customer:subscription:sync.rb' flintbit...") 
begin
     # Flintbit Input Parameters
     @connector_name = 'office365' # Name of the office365 Connector
     @id = @input.get('customer-id') # id of the Microsoft Account

     @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | Customer ID::#{@id}")

     response = @call.connector(@connector_name)
                     .set('action', 'get-all-customer-user-accounts')
                     .set('microsoft-id', @id)
                     .sync

     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message
     response_body = JSON.parse(response.get('body')) # parsing json string to JSON Object    
 
     if response_exitcode.zero?
         @log.info("Success in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @log.info("#{response_body}")
         @output.set("result", "#{response_body}")
       
     else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.exit(1, response_message)
end
 rescue Exception => e
     @log.error(e.message)
     @output.set('exit-code', 1).set('message', e.message)

 end
@log.trace("Finished execution 'flint-snow:microsoft-cloud:customer:subscription:sync.rb' flintbit...") # Execution Finished
