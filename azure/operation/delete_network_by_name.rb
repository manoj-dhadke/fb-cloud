# begin
require 'json'
@log.trace("Started executing 'fb-cloud:azure:operation:delete_network_by_name.rb' flintbit...")
begin
    # Flintbit Input Parameters
   # Mandatory
   @connector_name = @input.get('connector_name') #name of Azure connector
   @action = 'delete-network' #Specifies the name of the operation:delete-network
   @network_name= @input.get('network-name') #Name of the netowrk which you want to delete
   @group_name=@input.get('group-name') #name of the group-name in which the network is present

   @log.info("connector-name:#{@connector_name} | action :#{@action} | network-name:#{@network_name} | group-name: #{@group_name}")

   #optional
   @key = @input.get('key') #Azure account key
   @tenant_id = @input.get('tenant-id') #Azure account tenant-id
   @subscription_id = @input.get('subscription-id') #Azure account subscription-id
   @client_id = @input.get('client-id') #Azure client-id


   #Checking that the connector name is provided or not,if not then raise the exception with error message
   if @connector_name.nil? || @connector_name.empty?
       raise 'Please provide "MS Azure connector name (connector_name)" to delete network'
   end

   #Checking that the network name is provided or not,if not then raise the exception with error message
   if @network_name.nil? || @network_name.empty?
       raise 'Please provide "MS Azure network name(network_name)" to delete network'
   end

   #Checking that the group name is provided or not,if not then raise the exception with error message
   if @group_name.nil? ||  @group_name.empty?
       raise 'Please provide "MS Azure group name (group_name)" to delete network'
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

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message', response_message)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:delete_network_by_name.rb' flintbit")
# end
