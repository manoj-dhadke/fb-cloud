# begin
require 'json'
@log.trace("Started executing 'fb-cloud:azure:operation:create_subnet.rb' flintbit...")
begin
    # Flintbit Input Parameters
   # Mandatory
   @connector_name = @input.get('connector_name') #name of Azure connector
   @action = 'create-subnet' #Specifies the name of the operation:create-subnet
   @network_name= @input.get('network-name') #ID of the netowrk in which you want create subnet
   @subnet_name= @input.get("subnet-name")#name of the subnet which you want to create
   @address_spaces = @input.get('address-spaces') # provide address space in the form  of CIDR notion for the subnet


   @log.info("connector-name:#{@connector_name} | action :#{@action} | network-id:#{@network_id} | subnet-name:#{@subnet_name} | address-spaces:#{@address_spaces}")

   #optional
   @network_security_group_name=@input.get('security-group-name') #Network security group name which you want to attach to subnet
   @route_table_name=@input.get('route-table-name') #route table name to which you want to add the subnet
   @key = @input.get('key') #Azure accountid
   @tenant_id = @input.get('tenant-id') #Azure account tenant-id
   @subscription_id = @input.get('subscription-id') #Azure account subscription-id
   @client_id = @input.get('client-id') #Azure client-id
   @group_name= @input.get("group-name")#resource group name in which network is present

   #Checking that the connector name is provided or not,if not then raise the exception with error message
   if @connector_name.nil? || @connector_name.empty?
       raise 'Please provide "MS Azure connector name (connector_name)" to create subnet'
   end

   #Checking that the network name is provided or not,if not then raise the exception with error message
   if @network_name.nil? || @network_name.empty?
       raise 'Please provide "MS Azure network name(network_name)" in which you are going to create subnet'
   end

   # Checking that the network name is provided or not,if not then raise the exception with error message
   if @subnet_name.nil? || @subnet_name.empty?
       raise 'Please provide Azure subnet name (@network_name) to create subnet in given virtual network'
   end

   # Checking that the address spaces is provided or not,if not then raise the exception with error message
   if @address_spaces.nil? || @address_spaces.empty?
       raise 'Please provide Azure address spaces (@address_spaces) to create subnet virtual network'
   end

   connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('network-name',@network_name)
                          .set('subnet-name', @subnet_name)
                          .set('address-spaces', @address_spaces)
                          .set('security-group-name',@network_security_group_name)
                          .set('route-table-name',@route_table_name)
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

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message', response_message).set('network-details',network_details)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:create_subnet.rb' flintbit")
# end
