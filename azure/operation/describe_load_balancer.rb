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
require 'json'
@log.trace("Started executing 'fb-cloud:azure:operation:describe_load_balancer.rb' flintbit...")
begin
    # Flintbit Input Parameters
   # Mandatory
   @connector_name = @input.get('connector_name') #name of Azure connector
   @action = 'describe-load-balancer' #Specifies the name of the operation:describe-load-balancer
   @load_balancer_name = @input.get('load-balancer-name')
   @group_name = @input.get('group-name')

   #optional
   @key = @input.get('key') #Azure account key
   @tenant_id = @input.get('tenant-id') #Azure account tenant-id
   @subscription_id = @input.get('subscription-id') #Azure account subscription-id
   @client_id = @input.get('client-id') #Azure client-id


   #Checking that the connector name is provided or not,if not then raise the exception with error message
   if @connector_name.nil? || @connector_name.empty?
       raise 'Please provide "MS Azure connector name (connector_name)" to describe load balancer'
   end


   #Checking that the load balancer name is provided or not,if not then raise the exception with error message
   if @load_balancer_name.nil? || @load_balancer_name.empty?
       raise 'Please provide "MS Azure load-balancer-name (@load_balancer_name)" to describe load balancer'
   end

   #Checking that the connector name is provided or not,if not then raise the exception with error message
   if  @group_name.nil? ||  @group_name.empty?
       raise 'Please provide "MS Azure group-name (@group_name)" to describe load balancer'
   end

   connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('tenant-id', @tenant_id)
                          .set('subscription-id', @subscription_id)
                          .set('key', @key)
                          .set('client-id', @client_id)
                          .set('load-balancer-name',@load_balancer_name)
                          .set('group-name',@group_name)
                          .timeout(2800000)

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{@request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    # MS-azure Connector Response Meta Parameters
    response_exitcode = response.exitcode	# Exit status code
    response_message = response.message	# Execution status messages

    load_balancer_details=response.get('load-balancer-details')
    #load_balancer_details=@util.json(load_balancer_details)
    if response_exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message', response_message).set('load-balancer-details',load_balancer_details)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:describe_load_balancer.rb' flintbit")
# end
