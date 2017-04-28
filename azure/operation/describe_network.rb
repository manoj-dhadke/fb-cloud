# begin
require 'json'
@log.trace("Started executing 'fb-cloud:azure:operation:describe_network.rb' flintbit...")
begin
    # Flintbit Input Parameters
   # Mandatory
   @connector_name = @input.get('connector_name') #name of Azure connector
   @action = 'describe-network' #Specifies the name of the operation:describe-network
   @network_name= @input.get('network-name') #Name of the netowrk which you want to describe
   @group_name=@input.get('group-name') #name of the group-name in which the network is present

   @log.info("input details to connector ---------network-name:-#{@network_name} | group-name: #{@group_name}")

   #optional
   @key = @input.get('key') #Azure account key
   @tenant_id = @input.get('tenant-id') #Azure account tenant-id
   @subscription_id = @input.get('subscription-id') #Azure account subscription-id
   @client_id = @input.get('client-id') #Azure client-id


   #Checking that the connector name is provided or not,if not then raise the exception with error message
   if @connector_name.nil? || @connector_name.empty?
       raise 'Please provide "MS Azure connector name (connector_name)" to describe network'
   end

   #Checking that the connector name is provided or not,if not then raise the exception with error message
   if @network_name.nil? || @network_name.empty?
       raise 'Please provide "MS Azure network name(network_name)" to describe network'
   end

   if @group_name.nil? ||  @group_name.empty?
       raise 'Please provide "MS Azure group name (group_name)" to describe network'
   end

   connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('network-name',@network_name)
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

    network_details=response.get('network-details')
    if(!network_details.nil?)
    network_details=@util.json(network_details)
    end

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @log.info("network-details: #{network_details.to_s}")
        #@call.bit('flintcloud-integrations:services:http:http_services_helper.rb').set('action', 'sync_azure_vm').set('provide_ID', providerId).sync
        @output.set('exit-code', 0).set('message', response_message).setraw('network-details',network_details.to_s)
    else

        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:describe_network.rb' flintbit")
# end
