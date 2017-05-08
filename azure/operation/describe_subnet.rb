# begin
require 'json'
@log.trace("Started executing 'fb-cloud:azure:operation:describe_subnet.rb' flintbit...")
begin
    # Flintbit Input Parameters
   # Mandatory
   @connector_name = @input.get('connector_name') #name of Azure connector
   @action = 'describe-subnet' #Specifies the name of the operation:describe-subnet
   @network_id= @input.get('network-id') #ID of the netowrk in which subnet is present
   @subnet_name = @input.get("subnet-name")#name of the subnet which you want to describe

   @log.info("connector-name:#{@connector_name} | action :#{@action} | network-id:#{@network_id} | subnet-name:#{@subnet_name}")

   #optional
   @key = @input.get('key') #Azure accountid
   @tenant_id = @input.get('tenant-id') #Azure account tenant-id
   @subscription_id = @input.get('subscription-id') #Azure account subscription-id
   @client_id = @input.get('client-id') #Azure client-id


   #Checking that the connector name is provided or not,if not then raise the exception with error message
   if @connector_name.nil? || @connector_name.empty?
       raise 'Please provide "MS Azure connector name (connector_name)" to describe subnet'
   end

   #Checking that the network id is provided or not,if not then raise the exception with error message
   if @network_id.nil? || @network_id.empty?
       raise 'Please provide "MS Azure network id(@network_id)" to describe subnet'
   end

   #Checking that the subnet id is provided or not,if not then raise the exception with error message
   if @subnet_name.nil? || @subnet_name.empty?
       raise 'Please provide "MS Azure subnet name(@subnet_id)" to describe subnet'
   end


   connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('network-id',@network_id)
                          .set('subnet-name',@subnet_name)
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

    subnet_details=response.get('subnet-details')

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message', response_message).set('subnet-details',subnet_details)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:describe_subnet.rb' flintbit")
# end
